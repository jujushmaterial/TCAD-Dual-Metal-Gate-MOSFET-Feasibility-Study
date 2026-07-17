#setdep @node|sdevice@

puts "DEBUG: SVisual High-K Ig/CC-DIBL/Vtgm-corrected script started"
set n @node|sdevice@

set VgOff 0.0
set VgOn  2.5
set IdTarget_CC1 1.0e-7
set IdTarget_CC2 1.0e-8
set VgOp  @Vd_High@
set VdLow  @Vd_Low@
set VdHigh @Vd_High@

proc abs_list {input_list} {
  set output_list {}
  foreach v $input_list { lappend output_list [expr {abs($v) + 1.0e-30}] }
  return $output_list
}

proc add_lists {list_a list_b} {
  set output_list {}
  foreach a $list_a b $list_b { lappend output_list [expr {$a + $b}] }
  return $output_list
}

proc nearest_y {xlist ylist x0} {
  set best_diff 1.0e99
  set best_y 0.0
  foreach x $xlist y $ylist {
    set diff [expr {abs($x - $x0)}]
    if {$diff < $best_diff} { set best_diff $diff; set best_y $y }
  }
  return $best_y
}

proc max_y {ylist} {
  set max_value -1.0e99
  foreach y $ylist { if {$y > $max_value} { set max_value $y } }
  return $max_value
}

# Returns {Vth validFlag}; log-current interpolation is used at the first crossing.
proc vth_const_current {xlist ylist target} {
  set npts [llength $xlist]
  if {$target <= 0.0 || $npts < 2} { return [list 0.0 0] }

  for {set i 1} {$i < $npts} {incr i} {
    set x0 [lindex $xlist [expr {$i-1}]]
    set x1 [lindex $xlist $i]
    set y0 [lindex $ylist [expr {$i-1}]]
    set y1 [lindex $ylist $i]
    set f0 [expr {$y0 - $target}]
    set f1 [expr {$y1 - $target}]

    if {$f0 == 0.0} { return [list $x0 1] }
    if {$f1 == 0.0} { return [list $x1 1] }

    if {$f0*$f1 < 0.0} {
      if {$y0 > 0.0 && $y1 > 0.0 && $target > 0.0 && [expr {abs(log($y1)-log($y0))}] > 1.0e-30} {
        set vth [expr {$x0 + (log($target)-log($y0))*($x1-$x0)/(log($y1)-log($y0))}]
      } else {
        set vth [expr {$x0 + ($target-$y0)*($x1-$x0)/($y1-$y0)}]
      }
      return [list $vth 1]
    }
  }

  set best_diff 1.0e99
  set best_x 0.0
  foreach x $xlist y $ylist {
    set diff [expr {abs($y - $target)}]
    if {$diff < $best_diff} { set best_diff $diff; set best_x $x }
  }
  return [list $best_x 0]
}

proc extract_vth_cc {dataset_name target label} {
  set Vgs [get_variable_data "gateS OuterVoltage" -dataset $dataset_name]
  set Ids [abs_list [get_variable_data "drain TotalCurrent" -dataset $dataset_name]]
  set result [vth_const_current $Vgs $Ids $target]
  puts "DEBUG: $label target=$target Vth=[lindex $result 0] valid=[lindex $result 1]"
  return $result
}

proc format_value {value} {
  set avalue [expr {abs($value)}]
  if {$avalue == 0.0} { return [format %.2f $value] }
  if {$avalue >= 0.01 && $avalue < 1.0e6} { return [format %.4f $value] }
  return [format %.4e $value]
}

proc wb_scalar {name value} {
  set value_fmt [format_value $value]
  puts "DOE: $name $value_fmt"
  if {[llength [info commands ft_scalar]] > 0} { ft_scalar $name $value_fmt }
}

proc extract_idvg_params {dataset_name VgOff VgOn VdDrain label} {
  set Vgs [get_variable_data "gateS OuterVoltage" -dataset $dataset_name]
  set Ids [abs_list [get_variable_data "drain TotalCurrent" -dataset $dataset_name]]
  set npts [llength $Vgs]

  set gmList {}
  set gmXList {}
  for {set i 1} {$i < $npts} {incr i} {
    set x0 [lindex $Vgs [expr {$i-1}]]; set x1 [lindex $Vgs $i]
    set y0 [lindex $Ids [expr {$i-1}]]; set y1 [lindex $Ids $i]
    set dx [expr {$x1-$x0}]
    if {[expr {abs($dx)}] > 1.0e-30} {
      lappend gmList [expr {($y1-$y0)/$dx}]
      lappend gmXList [expr {0.5*($x0+$x1)}]
    }
  }

  set gmmax -1.0e99
  set Vgm 0.0
  foreach gx $gmXList gy $gmList {
    if {$gy > $gmmax} { set gmmax $gy; set Vgm $gx }
  }
  set Idgm [nearest_y $Vgs $Ids $Vgm]
  if {$gmmax <= 0.0} {
    set VtgmRaw 0.0; set Vtgm 0.0
  } else {
    set VtgmRaw [expr {$Vgm - $Idgm/$gmmax}]
    set Vtgm [expr {$VtgmRaw - 0.5*$VdDrain}]
  }

  set maxSlope -1.0e99
  for {set i 1} {$i < $npts} {incr i} {
    set x0 [lindex $Vgs [expr {$i-1}]]; set x1 [lindex $Vgs $i]
    set y0 [lindex $Ids [expr {$i-1}]]; set y1 [lindex $Ids $i]
    set dx [expr {$x1-$x0}]
    if {[expr {abs($dx)}] > 1.0e-30} {
      set slope [expr {(log($y1)/log(10.0)-log($y0)/log(10.0))/$dx}]
      if {$slope > $maxSlope} { set maxSlope $slope }
    }
  }
  if {$maxSlope <= 0.0} { set SS 1.0e99 } else { set SS [expr {1000.0/$maxSlope}] }

  set Ioff [nearest_y $Vgs $Ids $VgOff]
  set Ion [nearest_y $Vgs $Ids $VgOn]
  set IdMax [max_y $Ids]
  if {$Ioff == 0.0} { set IonIoff 1.0e99 } else { set IonIoff [expr {$Ion/$Ioff}] }

  return [list $Vtgm $Vtgm $SS $gmmax $Ion $Ioff $IonIoff $IdMax $VtgmRaw]
}

proc extract_ig_params {dataset_name VgOff VgOp VgOn label} {
  set Vgs [get_variable_data "gateS OuterVoltage" -dataset $dataset_name]
  set IgS [abs_list [get_variable_data "gateS TotalCurrent" -dataset $dataset_name]]
  set IgD [abs_list [get_variable_data "gateD TotalCurrent" -dataset $dataset_name]]
  set IgTotal [add_lists $IgS $IgD]

  return [list \
    [nearest_y $Vgs $IgS $VgOff] [nearest_y $Vgs $IgD $VgOff] [nearest_y $Vgs $IgTotal $VgOff] \
    [nearest_y $Vgs $IgS $VgOp]  [nearest_y $Vgs $IgD $VgOp]  [nearest_y $Vgs $IgTotal $VgOp] \
    [nearest_y $Vgs $IgS $VgOn]  [nearest_y $Vgs $IgD $VgOn]  [nearest_y $Vgs $IgTotal $VgOn] \
    [max_y $IgTotal]]
}

if {[llength [list_plots Plot_IdVg]] == 0} {
  create_plot -1d -name Plot_IdVg
  select_plots Plot_IdVg
  set_plot_prop -hide_title -show_legend
  set_axis_prop -title_font_size 16 -scale_font_size 14
  set_axis_prop -axis x -title "Gate Voltage (V)" -type linear
  set_axis_prop -axis y -title "Drain Current (A/<greek>m</greek>m)" -type log
  set_legend_prop -label_font_size 14 -location bottom_right
}

if {[llength [list_plots Plot_IgVg]] == 0} {
  create_plot -1d -name Plot_IgVg
  select_plots Plot_IgVg
  set_plot_prop -hide_title -show_legend
  set_axis_prop -title_font_size 16 -scale_font_size 14
  set_axis_prop -axis x -title "Gate Voltage (V)" -type linear
  set_axis_prop -axis y -title "Raw Gate Current (A/<greek>m</greek>m)" -type linear
  set_legend_prop -label_font_size 14 -location bottom_right
}

load_file @[relpath IdVg_Low_n@node|sdevice@_des.plt]@ -name PLT_LOW($n)
select_plots Plot_IdVg
create_curve -name IdVg_Low($n) -dataset PLT_LOW($n) -axisX "gateS OuterVoltage" -axisY "drain TotalCurrent"
select_plots Plot_IgVg
create_curve -name IgS_Low($n) -dataset PLT_LOW($n) -axisX "gateS OuterVoltage" -axisY "gateS TotalCurrent"
create_curve -name IgD_Low($n) -dataset PLT_LOW($n) -axisX "gateS OuterVoltage" -axisY "gateD TotalCurrent"

load_file @[relpath IdVg_High_n@node|sdevice@_des.plt]@ -name PLT_HIGH($n)
select_plots Plot_IdVg
create_curve -name IdVg_High($n) -dataset PLT_HIGH($n) -axisX "gateS OuterVoltage" -axisY "drain TotalCurrent"
select_plots Plot_IgVg
create_curve -name IgS_High($n) -dataset PLT_HIGH($n) -axisX "gateS OuterVoltage" -axisY "gateS TotalCurrent"
create_curve -name IgD_High($n) -dataset PLT_HIGH($n) -axisX "gateS OuterVoltage" -axisY "gateD TotalCurrent"

set lowParams [extract_idvg_params PLT_LOW($n) $VgOff $VgOn $VdLow "Low-Vd"]
set highParams [extract_idvg_params PLT_HIGH($n) $VgOff $VgOn $VdHigh "High-Vd"]

foreach prefix {Low High} params [list $lowParams $highParams] {
  set Vtgm_$prefix [lindex $params 0]
  set Vth_$prefix [lindex $params 1]
  set SS_$prefix [lindex $params 2]
  set gm_$prefix [lindex $params 3]
  set Ion_$prefix [lindex $params 4]
  set Ioff_$prefix [lindex $params 5]
  set IonIoff_$prefix [lindex $params 6]
  set IdMax_$prefix [lindex $params 7]
  set VtgmRaw_$prefix [lindex $params 8]
}

set lowCC1 [extract_vth_cc PLT_LOW($n) $IdTarget_CC1 "Low-Vd CC1"]
set highCC1 [extract_vth_cc PLT_HIGH($n) $IdTarget_CC1 "High-Vd CC1"]
set lowCC2 [extract_vth_cc PLT_LOW($n) $IdTarget_CC2 "Low-Vd CC2"]
set highCC2 [extract_vth_cc PLT_HIGH($n) $IdTarget_CC2 "High-Vd CC2"]

set VthCC1_Low [lindex $lowCC1 0]; set VthCC1_Valid_Low [lindex $lowCC1 1]
set VthCC1_High [lindex $highCC1 0]; set VthCC1_Valid_High [lindex $highCC1 1]
set VthCC2_Low [lindex $lowCC2 0]; set VthCC2_Valid_Low [lindex $lowCC2 1]
set VthCC2_High [lindex $highCC2 0]; set VthCC2_Valid_High [lindex $highCC2 1]

set lowIgParams [extract_ig_params PLT_LOW($n) $VgOff $VgOp $VgOn "Low-Vd"]
set highIgParams [extract_ig_params PLT_HIGH($n) $VgOff $VgOp $VgOn "High-Vd"]

foreach prefix {Low High} params [list $lowIgParams $highIgParams] {
  set IgS_Off_$prefix [lindex $params 0]; set IgD_Off_$prefix [lindex $params 1]
  set IgTotal_Off_$prefix [lindex $params 2]; set IgS_Op_$prefix [lindex $params 3]
  set IgD_Op_$prefix [lindex $params 4]; set IgTotal_Op_$prefix [lindex $params 5]
  set IgS_On_$prefix [lindex $params 6]; set IgD_On_$prefix [lindex $params 7]
  set IgTotal_On_$prefix [lindex $params 8]; set IgTotal_Max_$prefix [lindex $params 9]
}

set TotalLeak_Off_Low [expr {$Ioff_Low + $IgTotal_Off_Low}]
set TotalLeak_Off_High [expr {$Ioff_High + $IgTotal_Off_High}]
set dVd [expr {$VdHigh-$VdLow}]

if {[expr {abs($dVd)}] < 1.0e-30} {
  set Signed_DIBL_CC1_VperV 0.0; set DIBL_CC1_VperV 0.0
  set Signed_DIBL_CC2_VperV 0.0; set DIBL_CC2_VperV 0.0
  set Signed_DIBL_Vtgm_VperV 0.0; set DIBL_VtgmAbs_VperV 0.0
} else {
  set Signed_DIBL_CC1_VperV [expr {($VthCC1_Low-$VthCC1_High)/$dVd}]
  set DIBL_CC1_VperV [expr {abs($Signed_DIBL_CC1_VperV)}]
  set Signed_DIBL_CC2_VperV [expr {($VthCC2_Low-$VthCC2_High)/$dVd}]
  set DIBL_CC2_VperV [expr {abs($Signed_DIBL_CC2_VperV)}]
  set Signed_DIBL_Vtgm_VperV [expr {($Vtgm_Low-$Vtgm_High)/$dVd}]
  set DIBL_VtgmAbs_VperV [expr {abs($Signed_DIBL_Vtgm_VperV)}]
}

set DIBL_CC1_mVperV [expr {$DIBL_CC1_VperV*1000.0}]
set DIBL_CC2_mVperV [expr {$DIBL_CC2_VperV*1000.0}]
set DIBL_VtgmAbs_mVperV [expr {$DIBL_VtgmAbs_VperV*1000.0}]
set DIBL_VperV $DIBL_CC1_VperV
set DIBL_mVperV $DIBL_CC1_mVperV

foreach {name value} [list \
  Vth_Low $Vth_Low Vth_High $Vth_High VtgmRaw_Low $VtgmRaw_Low VtgmRaw_High $VtgmRaw_High \
  Vtgm_Low $Vtgm_Low Vtgm_High $Vtgm_High IdTarget_CC1 $IdTarget_CC1 \
  VthCC1_Low $VthCC1_Low VthCC1_High $VthCC1_High VthCC1_Valid_Low $VthCC1_Valid_Low \
  VthCC1_Valid_High $VthCC1_Valid_High Signed_DIBL_CC1_VperV $Signed_DIBL_CC1_VperV \
  DIBL_CC1_mVperV $DIBL_CC1_mVperV IdTarget_CC2 $IdTarget_CC2 VthCC2_Low $VthCC2_Low \
  VthCC2_High $VthCC2_High VthCC2_Valid_Low $VthCC2_Valid_Low VthCC2_Valid_High $VthCC2_Valid_High \
  DIBL_CC2_mVperV $DIBL_CC2_mVperV Signed_DIBL_Vtgm_VperV $Signed_DIBL_Vtgm_VperV \
  DIBL_VtgmAbs_mVperV $DIBL_VtgmAbs_mVperV DIBL_VperV $DIBL_VperV DIBL_mVperV $DIBL_mVperV \
  SS_Low $SS_Low SS_High $SS_High gm_Low $gm_Low gm_High $gm_High Ion_Low $Ion_Low Ion_High $Ion_High \
  Ioff_Low $Ioff_Low Ioff_High $Ioff_High IonIoff_Low $IonIoff_Low IonIoff_High $IonIoff_High \
  IgTotal_Off_Low $IgTotal_Off_Low IgTotal_Op_Low $IgTotal_Op_Low IgTotal_On_Low $IgTotal_On_Low \
  IgTotal_Off_High $IgTotal_Off_High IgTotal_Op_High $IgTotal_Op_High IgTotal_On_High $IgTotal_On_High \
  TotalLeak_Off_Low $TotalLeak_Off_Low TotalLeak_Off_High $TotalLeak_Off_High] {
  wb_scalar $name $value
}

puts "DEBUG: SVisual Ig/CC-DIBL/Vtgm-corrected script finished"
