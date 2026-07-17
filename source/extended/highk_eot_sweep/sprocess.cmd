# SProcess: 28 nm High-K variable-EOT Dual-Metal Gate MOSFET
# EOT_Target is a Workbench parameter in micrometers.

#header
#endheader

set GateCapThick   0.020
set GateCapEtch    0.030
set GateMetalThick 0.050
set GateMetalEtch  0.070
set AlContactThick 0.050
set AlContactEtch  0.080
set SpacerThick    [expr 0.25*@Lg@]
set SpacerEtch     [expr 1.20*$SpacerThick]

# High-K stack
set T_IL       0.0005
set K_SiO2     3.9
set K_HfO2     20.0
set EOT_Target @EOT_Target@

if { $EOT_Target <= $T_IL } {
  error "EOT_Target must be larger than T_IL."
}

# EOT = T_IL + T_HK*k_SiO2/k_HfO2
set T_HK  [expr ($EOT_Target-$T_IL)*$K_HfO2/$K_SiO2]
set T_PHY [expr $T_IL+$T_HK]
set EOT   [expr $T_IL+$T_HK*$K_SiO2/$K_HfO2]

# Gate-ratio parameterization
if { @DMG_Gap@ <= 0.0 || @DMG_Gap@ >= @Lg@ } {
  error "DMG_Gap must be positive and smaller than Lg."
}
if { @DMG_RatioS@ <= 0.0 || @DMG_RatioS@ >= 1.0 } {
  error "DMG_RatioS must be between 0 and 1."
}

set LMetal       [expr @Lg@-@DMG_Gap@]
set DMG_RatioD   [expr 1.0-@DMG_RatioS@]
set GateS_Len    [expr @DMG_RatioS@*$LMetal]
set GateD_Len    [expr $DMG_RatioD*$LMetal]
set GateS_Left   [expr -0.5*@Lg@]
set GateS_Right  [expr $GateS_Left+$GateS_Len]
set GateD_Left   [expr $GateS_Right+@DMG_Gap@]
set GateD_Right  [expr 0.5*@Lg@]
set GateS_Center [expr 0.5*($GateS_Left+$GateS_Right)]
set GateD_Center [expr 0.5*($GateD_Left+$GateD_Right)]

# Mesh and domain
line x location= 0.000 spacing= 0.002 tag= top
line x location= 0.030 spacing= 0.003
line x location= 0.080 spacing= 0.008
line x location= 0.150 spacing= 0.020
line x location= 0.400 spacing= 0.050 tag= bottom

line y location= -4*@Lg@    spacing= @Lg@       tag= left
line y location= -2*@Lg@    spacing= 0.25*@Lg@
line y location= -1.0*@Lg@  spacing= 0.08*@Lg@
line y location= -0.5*@Lg@  spacing= 0.03*@Lg@
line y location=  0.0       spacing= 0.01*@Lg@
line y location=  0.5*@Lg@  spacing= 0.03*@Lg@
line y location=  1.0*@Lg@  spacing= 0.08*@Lg@
line y location=  2*@Lg@    spacing= 0.25*@Lg@
line y location=  4*@Lg@    spacing= @Lg@       tag= right

region Silicon xlo= top xhi= bottom ylo= left yhi= right

# Initialization
init concentration= @NWell@ field= Boron slice.angle= 180 !DelayFullD
pdbSet Silicon Dopant DiffModel ChargedFermi
struct tdr= JH_n@node@_01_initialize !Gas !interfaces

# Variable-EOT gate dielectric
pdbSet Oxide Grid perp.add.dist 0.005e-4
deposit Oxide type= anisotropic thickness= $T_IL
pdbSet HfO2 Grid perp.add.dist 0.005e-4
deposit material= {HfO2} type= anisotropic thickness= $T_HK
struct tdr= JH_n@node@_02_highk_stack !Gas !interfaces

puts "DOE: EOT_Target_nm [format %.4f [expr $EOT_Target*1000.0]]"
puts "DOE: T_IL_nm [format %.4f [expr $T_IL*1000.0]]"
puts "DOE: T_HK_nm [format %.4f [expr $T_HK*1000.0]]"
puts "DOE: T_PHY_nm [format %.4f [expr $T_PHY*1000.0]]"
puts "DOE: EOT_nm [format %.4f [expr $EOT*1000.0]]"
puts "DOE: DMG_RatioS [format %.4f [expr @DMG_RatioS@]]"
puts "DOE: DMG_RatioD [format %.4f [expr $DMG_RatioD]]"
puts "DOE: GateS_Len_nm [format %.4f [expr $GateS_Len*1000.0]]"
puts "DOE: GateD_Len_nm [format %.4f [expr $GateD_Len*1000.0]]"
puts "DOE: DMG_Gap_nm [format %.4f [expr @DMG_Gap@*1000.0]]"

# GateS formation
deposit material= {Titanium} type= anisotropic thickness= $GateMetalThick
mask name= gateS left= $GateS_Left right= $GateS_Right
etch material= {Titanium} type= anisotropic thickness= $GateMetalEtch mask= gateS
struct tdr= JH_n@node@_03_gateS_formation !Gas !interfaces

# GateD formation
deposit material= {Tungsten} type= anisotropic thickness= $GateMetalThick
mask name= gateD left= $GateD_Left right= $GateD_Right
etch material= {Tungsten} type= anisotropic thickness= $GateMetalEtch mask= gateD
struct tdr= JH_n@node@_04_gateD_formation !Gas !interfaces

# Dielectric etch outside the gate region
mask name= gateAll left= -@Lg@/2 right= @Lg@/2
etch material= {HfO2} type= anisotropic thickness= 0.020 mask= gateAll
etch Oxide type= anisotropic thickness= 0.020 mask= gateAll
struct tdr= JH_n@node@_05_gate_dielectric_etch !Gas !interfaces

# Temporary gate/gap implant-block cap
deposit Nitride type= anisotropic thickness= $GateCapThick
struct tdr= JH_n@node@_06a_gate_cap_depo !Gas !interfaces
mask name= gateCap left= -@Lg@/2 right= @Lg@/2
etch Nitride type= anisotropic thickness= $GateCapEtch mask= gateCap
struct tdr= JH_n@node@_06b_gate_gap_cap_etch !Gas !interfaces

# LDD
implant Arsenic dose= @LDD_Dose@ energy= @LDD_E@
struct tdr= JH_n@node@_07_LDD_implant !Gas !interfaces

# Spacer
deposit Nitride type= isotropic thickness= $SpacerThick
struct tdr= JH_n@node@_08_spacer_depo !Gas !interfaces
etch Nitride type= anisotropic thickness= $SpacerEtch mask= gateCap
struct tdr= JH_n@node@_09_spacer_etch_cap_kept !Gas !interfaces

# Source/drain implant and anneal
implant Phosphorus dose= @SD_Dose@ energy= @SD_E@
struct tdr= JH_n@node@_10_SD_implant !Gas !interfaces
diffuse time=0.5<s> temperature= 950
struct tdr= JH_n@node@_11_SD_anneal !Gas !interfaces

# Remove the temporary gate cap while retaining outer nitride
mask name= keepOuterNitride segments= { -4*@Lg@ -@Lg@/2  @Lg@/2 4*@Lg@ }
set GateCapStripThick [expr $GateCapThick+1.50*$SpacerThick]
etch Nitride type= anisotropic thickness= $GateCapStripThick mask= keepOuterNitride
struct tdr= JH_n@node@_12_gate_cap_removed !Gas !interfaces

# Aluminum source/drain contacts
deposit Aluminum type= anisotropic thickness= $AlContactThick
mask name= contact segments= { -4*@Lg@ -2.2*@Lg@  2.2*@Lg@ 4*@Lg@ }
etch Aluminum type= anisotropic thickness= $AlContactEtch mask= contact
struct tdr= JH_n@node@_13_Al_contact !Gas !interfaces

# Contacts; no reflect because DMG is laterally asymmetric
contact name= substrate bottom
contact name= source point y= -3.0*@Lg@ x= -0.010 replace
contact name= drain  point y=  3.0*@Lg@ x= -0.010 replace
contact name= gateS point y= $GateS_Center x= -0.025 replace
contact name= gateD point y= $GateD_Center x= -0.025 replace

struct tdr= n@node@ !Gas !interfaces
