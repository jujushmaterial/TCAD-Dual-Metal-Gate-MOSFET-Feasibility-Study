#setdep @node|sdevice@

puts "DEBUG: SVisual Ig script started"
set n @node|sdevice@

set VgOff 0.0
set VgOn  2.5
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

proc format_value {value} {
  set avalue [expr {abs($value)}]
  if {$avalue == 0.0} {
    return [format %.2f $value]
  } elseif {$avalue >= 0.01 && $avalue < 1.0e6} {
    return [format %.2f $value]
  } else {
    return [format %.4e $value]
  }
}

proc wb_scalar {name value} {
  set value_fmt [format_value $value]
  puts "DOE: $name $value_fmt"
  if {[llength [info commands ft_scalar]] > 0} { ft_scalar $name $value_fmt }
}

proc extract_idvg_params {dataset_name VgOff VgOn label} {
  set Vgs     [get_variable_data "gateS OuterVoltage" -dataset $dataset_name]
  set Ids_raw [get_variable_data "drain TotalCurrent" -dataset $dataset_name]
  set Ids [abs_list $Ids_raw]

  puts "DEBUG: $label Id data loaded"
  puts "DEBUG: $label Vgs points = [llength $Vgs]"
  puts "DEBUG: $label Ids points = [llength $Ids]"

  set gmList {}
  set gmXList {}
  set npts [llength $Vgs]

  for {set i 1} {$i < $npts} {incr i} {
    set x0 [lindex $Vgs [expr {$i-1}]]
    set x1 [lindex $Vgs $i]
    set y0 [lindex $Ids [expr {$i-1}]]
    set y1 [lindex $Ids $i]
    set dx [expr {$x1 - $x0}]
    if {[expr {abs($dx)}] > 1.0e-30} {
      lappend gmList [expr {($y1 - $y0) / $dx}]
      lappend gmXList [expr {0.5 * ($x0 + $x1)}]
    }
  }

  set gmmax -1.0e99
  set Vgm 0.0
  foreach gx $gmXList gy $gmList {
    if {$gy > $gmmax} { set gmmax $gy; set Vgm $gx }
  }

  set Idgm [nearest_y $Vgs $Ids $Vgm]
  if {$gmmax <= 0.0} { set Vtgm 0.0 } else { set Vtgm [expr {$Vgm - ($Idgm / $gmmax)}] }
  set Vth $Vtgm
  set gm $gmmax

  set maxSlope -1.0e99
  for {set i 1} {$i < $npts} {incr i} {
    set x0 [lindex $Vgs [expr {$i-1}]]
    set x1 [lindex $Vgs $i]
    set y0 [lindex $Ids [expr {$i-1}]]
    set y1 [lindex $Ids $i]
    set dx [expr {$x1 - $x0}]
    if {[expr {abs($dx)}] > 1.0e-30} {
      set log0 [expr {log($y0) / log(10.0)}]
      set log1 [expr {log($y1) / log(10.0)}]
      set slope [expr {($log1 - $log0) / $dx}]
      if {$slope > $maxSlope} { set maxSlope $slope }
    }
  }
  if {$maxSlope <= 0.0} { set SS 1.0e99 } else { set SS [expr {1000.0 / $maxSlope}] }

  set Ioff [nearest_y $Vgs $Ids $VgOff]
  set Ion  [nearest_y $Vgs $Ids $VgOn]
  set IdMax [max_y $Ids]
  if {$Ioff == 0.0} { set IonIoff 1.0e99 } else { set IonIoff [expr {$Ion / $Ioff}] }

  return [list $Vtgm $Vth $SS $gm $Ion $Ioff $IonIoff $IdMax]
}

proc extract_ig_params {dataset_name VgOff VgOn label} {
  set Vgs     [get_variable_data "gateS OuterVoltage" -dataset $dataset_name]
  set IgS_raw [get_variable_data "gateS TotalCurrent" -dataset $dataset_name]
  set IgD_raw [get_variable_data "gateD TotalCurrent" -dataset $dataset_name]

  set IgS [abs_list $IgS_raw]
  set IgD [abs_list $IgD_raw]
  set IgTotal [add_lists $IgS $IgD]

  puts "DEBUG: $label Ig data loaded"
  puts "DEBUG: $label IgS points = [llength $IgS]"
  puts "DEBUG: $label IgD points = [llength $IgD]"

  set IgS_Off     [nearest_y $Vgs $IgS $VgOff]
  set IgD_Off     [nearest_y $Vgs $IgD $VgOff]
  set IgTotal_Off [nearest_y $Vgs $IgTotal $VgOff]
  set IgS_On      [nearest_y $Vgs $IgS $VgOn]
  set IgD_On      [nearest_y $Vgs $IgD $VgOn]
  set IgTotal_On  [nearest_y $Vgs $IgTotal $VgOn]
  set IgTotal_Max [max_y $IgTotal]

  return [list $IgS_Off $IgD_Off $IgTotal_Off $IgS_On $IgD_On $IgTotal_On $IgTotal_Max]
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

set lowParams [extract_idvg_params PLT_LOW($n) $VgOff $VgOn "Low-Vd"]
set Vtgm_Low [lindex $lowParams 0]; set Vth_Low [lindex $lowParams 1]
set SS_Low [lindex $lowParams 2]; set gm_Low [lindex $lowParams 3]
set Ion_Low [lindex $lowParams 4]; set Ioff_Low [lindex $lowParams 5]
set IonIoff_Low [lindex $lowParams 6]; set IdMax_Low [lindex $lowParams 7]

set highParams [extract_idvg_params PLT_HIGH($n) $VgOff $VgOn "High-Vd"]
set Vtgm_High [lindex $highParams 0]; set Vth_High [lindex $highParams 1]
set SS_High [lindex $highParams 2]; set gm_High [lindex $highParams 3]
set Ion_High [lindex $highParams 4]; set Ioff_High [lindex $highParams 5]
set IonIoff_High [lindex $highParams 6]; set IdMax_High [lindex $highParams 7]

set lowIgParams [extract_ig_params PLT_LOW($n) $VgOff $VgOn "Low-Vd"]
set IgS_Off_Low [lindex $lowIgParams 0]; set IgD_Off_Low [lindex $lowIgParams 1]
set IgTotal_Off_Low [lindex $lowIgParams 2]; set IgS_On_Low [lindex $lowIgParams 3]
set IgD_On_Low [lindex $lowIgParams 4]; set IgTotal_On_Low [lindex $lowIgParams 5]
set IgTotal_Max_Low [lindex $lowIgParams 6]

set highIgParams [extract_ig_params PLT_HIGH($n) $VgOff $VgOn "High-Vd"]
set IgS_Off_High [lindex $highIgParams 0]; set IgD_Off_High [lindex $highIgParams 1]
set IgTotal_Off_High [lindex $highIgParams 2]; set IgS_On_High [lindex $highIgParams 3]
set IgD_On_High [lindex $highIgParams 4]; set IgTotal_On_High [lindex $highIgParams 5]
set IgTotal_Max_High [lindex $highIgParams 6]

set TotalLeak_Off_Low [expr {$Ioff_Low + $IgTotal_Off_Low}]
set TotalLeak_Off_High [expr {$Ioff_High + $IgTotal_Off_High}]

set dVd [expr {$VdHigh - $VdLow}]
if {[expr {abs($dVd)}] < 1.0e-30} {
  set DIBL_VperV 0.0; set DIBL_mVperV 0.0
} else {
  set DIBL_VperV [expr {abs(($Vth_Low - $Vth_High) / $dVd)}]
  set DIBL_mVperV [expr {$DIBL_VperV * 1000.0}]
}

foreach {name value} [list \
  Vth_Low $Vth_Low Vth_High $Vth_High Vtgm_Low $Vtgm_Low Vtgm_High $Vtgm_High \
  DIBL_VperV $DIBL_VperV DIBL_mVperV $DIBL_mVperV SS_Low $SS_Low SS_High $SS_High \
  gm_Low $gm_Low gm_High $gm_High Ion_Low $Ion_Low Ion_High $Ion_High \
  Ioff_Low $Ioff_Low Ioff_High $Ioff_High IonIoff_Low $IonIoff_Low IonIoff_High $IonIoff_High \
  IdMax_Low $IdMax_Low IdMax_High $IdMax_High IgS_Off_Low $IgS_Off_Low IgD_Off_Low $IgD_Off_Low \
  IgTotal_Off_Low $IgTotal_Off_Low IgS_On_Low $IgS_On_Low IgD_On_Low $IgD_On_Low \
  IgTotal_On_Low $IgTotal_On_Low IgTotal_Max_Low $IgTotal_Max_Low \
  IgS_Off_High $IgS_Off_High IgD_Off_High $IgD_Off_High IgTotal_Off_High $IgTotal_Off_High \
  IgS_On_High $IgS_On_High IgD_On_High $IgD_On_High IgTotal_On_High $IgTotal_On_High \
  IgTotal_Max_High $IgTotal_Max_High TotalLeak_Off_Low $TotalLeak_Off_Low TotalLeak_Off_High $TotalLeak_Off_High] {
  wb_scalar $name $value
}

puts "DEBUG: SVisual Ig script finished"
