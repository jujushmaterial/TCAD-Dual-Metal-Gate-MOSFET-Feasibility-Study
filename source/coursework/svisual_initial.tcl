#setdep @node|sdevice@

puts "DEBUG: SVisual script started"

set n @node|sdevice@

#------------------------------------------------------------
# User settings
#------------------------------------------------------------

set VgOff 0.0
set VgOn  2.5

set VdLow  @Vd_Low@
set VdHigh @Vd_High@

#------------------------------------------------------------
# Utility functions
#------------------------------------------------------------

proc abs_list {input_list} {
  set output_list {}
  foreach v $input_list {
    lappend output_list [expr {abs($v) + 1.0e-30}]
  }
  return $output_list
}

proc nearest_y {xlist ylist x0} {
  set best_diff 1.0e99
  set best_y 0.0

  foreach x $xlist y $ylist {
    set diff [expr {abs($x - $x0)}]
    if {$diff < $best_diff} {
      set best_diff $diff
      set best_y $y
    }
  }

  return $best_y
}

proc max_y {ylist} {
  set max_value -1.0e99

  foreach y $ylist {
    if {$y > $max_value} {
      set max_value $y
    }
  }

  return $max_value
}

#------------------------------------------------------------
# Flexible number format
#
# 0.01 <= abs(value) < 1e6  : decimal, two digits
# abs(value) < 0.01         : scientific notation
# abs(value) >= 1e6         : scientific notation
#
# Example:
# 123.456    -> 123.46
# 0.456      -> 0.46
# 0.0123     -> 0.01
# 0.000123   -> 1.2300e-04
# 123456789  -> 1.2346e+08
#------------------------------------------------------------

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

#------------------------------------------------------------
# Workbench DOE output function
#------------------------------------------------------------

proc wb_scalar {name value} {
  set value_fmt [format_value $value]

  puts "DOE: $name $value_fmt"

  if {[llength [info commands ft_scalar]] > 0} {
    ft_scalar $name $value_fmt
  }
}

#------------------------------------------------------------
# Extract Id-Vg parameters from one dataset
#------------------------------------------------------------

proc extract_idvg_params {dataset_name VgOff VgOn label} {

  set Vgs     [get_variable_data "gateS OuterVoltage"  -dataset $dataset_name]
  set Ids_raw [get_variable_data "drain TotalCurrent" -dataset $dataset_name]

  set Ids [abs_list $Ids_raw]

  puts "DEBUG: $label data loaded"
  puts "DEBUG: $label Vgs points = [llength $Vgs]"
  puts "DEBUG: $label Ids points = [llength $Ids]"

  #------------------------------------------------------------
  # Manual gm extraction
  # gm = dId/dVg
  #------------------------------------------------------------

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
      set gm_i [expr {($y1 - $y0) / $dx}]
      set xmid [expr {0.5 * ($x0 + $x1)}]

      lappend gmList $gm_i
      lappend gmXList $xmid
    }
  }

  set gmmax -1.0e99
  set Vgm 0.0

  foreach gx $gmXList gy $gmList {
    if {$gy > $gmmax} {
      set gmmax $gy
      set Vgm $gx
    }
  }

  set Idgm [nearest_y $Vgs $Ids $Vgm]

  if {$gmmax <= 0.0} {
    set Vtgm 0.0
  } else {
    set Vtgm [expr {$Vgm - ($Idgm / $gmmax)}]
  }

  set Vth $Vtgm
  set gm $gmmax

  #------------------------------------------------------------
  # Manual SS extraction
  # SS = 1000 / max(dlog10(Id)/dVg)
  # unit: mV/dec
  #------------------------------------------------------------

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

      if {$slope > $maxSlope} {
        set maxSlope $slope
      }
    }
  }

  if {$maxSlope <= 0.0} {
    set SS 1.0e99
  } else {
    set SS [expr {1000.0 / $maxSlope}]
  }

  #------------------------------------------------------------
  # Ion / Ioff / IonIoff
  #------------------------------------------------------------

  set Ioff [nearest_y $Vgs $Ids $VgOff]
  set Ion  [nearest_y $Vgs $Ids $VgOn]
  set IdMax [max_y $Ids]

  if {$Ioff == 0.0} {
    set IonIoff 1.0e99
  } else {
    set IonIoff [expr {$Ion / $Ioff}]
  }

  return [list $Vtgm $Vth $SS $gm $Ion $Ioff $IonIoff $IdMax]
}

#------------------------------------------------------------
# Create plot
#------------------------------------------------------------

if {[llength [list_plots Plot_1D]] == 0} {
  create_plot -1d -name Plot_1D
  select_plots Plot_1D

  set_plot_prop -hide_title -show_legend

  set_axis_prop -title_font_size 16 -scale_font_size 14
  set_axis_prop -axis x -title "Gate Voltage (V)" -type linear
  set_axis_prop -axis y -title "Drain Current (A/<greek>m</greek>m)" -type log

  set_legend_prop -label_font_size 14 -location bottom_right
}

#------------------------------------------------------------
# Load Low-Vd Id-Vg data
#------------------------------------------------------------

puts "DEBUG: loading Low-Vd IdVg file = @[relpath IdVg_Low_n@node|sdevice@_des.plt]@"

load_file @[relpath IdVg_Low_n@node|sdevice@_des.plt]@ -name PLT_LOW($n)

puts "DEBUG: Low-Vd IdVg file loaded"

create_curve -name IdVg_Low($n) -dataset PLT_LOW($n) \
  -axisX "gateS OuterVoltage" -axisY "drain TotalCurrent"

#------------------------------------------------------------
# Load High-Vd Id-Vg data
#------------------------------------------------------------

puts "DEBUG: loading High-Vd IdVg file = @[relpath IdVg_High_n@node|sdevice@_des.plt]@"

load_file @[relpath IdVg_High_n@node|sdevice@_des.plt]@ -name PLT_HIGH($n)

puts "DEBUG: High-Vd IdVg file loaded"

create_curve -name IdVg_High($n) -dataset PLT_HIGH($n) \
  -axisX "gateS OuterVoltage" -axisY "drain TotalCurrent"

#------------------------------------------------------------
# Extract Low-Vd parameters
#------------------------------------------------------------

set lowParams [extract_idvg_params PLT_LOW($n) $VgOff $VgOn "Low-Vd"]

set Vtgm_Low    [lindex $lowParams 0]
set Vth_Low     [lindex $lowParams 1]
set SS_Low      [lindex $lowParams 2]
set gm_Low      [lindex $lowParams 3]
set Ion_Low     [lindex $lowParams 4]
set Ioff_Low    [lindex $lowParams 5]
set IonIoff_Low [lindex $lowParams 6]
set IdMax_Low   [lindex $lowParams 7]

#------------------------------------------------------------
# Extract High-Vd parameters
#------------------------------------------------------------

set highParams [extract_idvg_params PLT_HIGH($n) $VgOff $VgOn "High-Vd"]

set Vtgm_High    [lindex $highParams 0]
set Vth_High     [lindex $highParams 1]
set SS_High      [lindex $highParams 2]
set gm_High      [lindex $highParams 3]
set Ion_High     [lindex $highParams 4]
set Ioff_High    [lindex $highParams 5]
set IonIoff_High [lindex $highParams 6]
set IdMax_High   [lindex $highParams 7]

#------------------------------------------------------------
# DIBL extraction
#
# DIBL = abs((Vth_lowVd - Vth_highVd) / (Vd_high - Vd_low))
# unit:
#   DIBL_VperV  = V/V
#   DIBL_mVperV = mV/V
#------------------------------------------------------------

set dVd [expr {$VdHigh - $VdLow}]

if {[expr {abs($dVd)}] < 1.0e-30} {
  set DIBL_VperV 0.0
  set DIBL_mVperV 0.0
} else {
  set DIBL_VperV_raw  [expr {($Vth_Low - $Vth_High) / $dVd}]
  set DIBL_VperV      [expr {abs($DIBL_VperV_raw)}]
  set DIBL_mVperV     [expr {$DIBL_VperV * 1000.0}]
}

#------------------------------------------------------------
# Console output
#------------------------------------------------------------

puts "=========================================="
puts "Dual-Metal Gate MOSFET DIBL Extraction"
puts "=========================================="
puts "Vd_Low        = [format_value $VdLow] V"
puts "Vd_High       = [format_value $VdHigh] V"
puts "Vth_Low       = [format_value $Vth_Low] V"
puts "Vth_High      = [format_value $Vth_High] V"
puts "Vtgm_Low      = [format_value $Vtgm_Low] V"
puts "Vtgm_High     = [format_value $Vtgm_High] V"
puts "DIBL          = [format_value $DIBL_mVperV] mV/V"
puts "SS_Low        = [format_value $SS_Low] mV/dec"
puts "SS_High       = [format_value $SS_High] mV/dec"
puts "gm_Low        = [format_value $gm_Low]"
puts "gm_High       = [format_value $gm_High]"
puts "Ion_Low       = [format_value $Ion_Low] A"
puts "Ion_High      = [format_value $Ion_High] A"
puts "Ioff_Low      = [format_value $Ioff_Low] A"
puts "Ioff_High     = [format_value $Ioff_High] A"
puts "Ion/Ioff_Low  = [format_value $IonIoff_Low]"
puts "Ion/Ioff_High = [format_value $IonIoff_High]"
puts "IdMax_Low     = [format_value $IdMax_Low] A"
puts "IdMax_High    = [format_value $IdMax_High] A"
puts "=========================================="

#------------------------------------------------------------
# Workbench DOE output
#------------------------------------------------------------

wb_scalar Vth_Low        $Vth_Low
wb_scalar Vth_High       $Vth_High
wb_scalar Vtgm_Low       $Vtgm_Low
wb_scalar Vtgm_High      $Vtgm_High

wb_scalar DIBL_VperV     $DIBL_VperV
wb_scalar DIBL_mVperV    $DIBL_mVperV

wb_scalar SS_Low         $SS_Low
wb_scalar SS_High        $SS_High

wb_scalar gm_Low         $gm_Low
wb_scalar gm_High        $gm_High

wb_scalar Ion_Low        $Ion_Low
wb_scalar Ion_High       $Ion_High

wb_scalar Ioff_Low       $Ioff_Low
wb_scalar Ioff_High      $Ioff_High

wb_scalar IonIoff_Low    $IonIoff_Low
wb_scalar IonIoff_High   $IonIoff_High

wb_scalar IdMax_Low      $IdMax_Low
wb_scalar IdMax_High     $IdMax_High

#------------------------------------------------------------
# Curve properties
#------------------------------------------------------------

if {[info exists runVisualizerNodesTogether]} {
  set_curve_prop IdVg_Low($n) -label "Low Vd IdVg $legend" \
    -color $color -line_style $line -line_width 3

  set_curve_prop IdVg_High($n) -label "High Vd IdVg $legend" \
    -color $color -line_style dashed -line_width 3
} else {
  puts "To see the curves, select both Sentaurus Visual nodes and at the toolbar"
  puts "press the \"Run selected Visualizer Nodes Together\" button."
}

puts "DEBUG: SVisual script finished"
