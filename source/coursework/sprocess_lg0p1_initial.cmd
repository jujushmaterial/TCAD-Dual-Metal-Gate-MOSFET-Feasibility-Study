#header

#endheader

#-----------------------------------------------------------------------
# Full MOSFET with Dual-Metal Gate
# y < 0 : source side
# y > 0 : drain side
# gateS : source-side low workfunction metal
# gateD : drain-side high workfunction metal
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# Implant conditions
# LDD_Dose만 Workbench 변수로 사용
# 나머지 Energy / Dose 값은 SimpleMOS 기준 상수값으로 고정
#-----------------------------------------------------------------------

# Temporary gate/gap implant-block cap thickness
# Purpose: prevent n-type dopant penetration through DMG gap
set GateCapThick 0.020
set GateCapEtch  0.030

line x location= 0    spacing= 0.01 tag= top
line x location= 0.15 spacing= 0.02
line x location= 1.0  spacing= 0.2  tag= bottom

line y location= -2*@Lg@    spacing= @Lg@       tag= left
line y location= -0.5*@Lg@  spacing= 0.05*@Lg@
line y location= 0.0        spacing= 0.02*@Lg@
line y location= 0.5*@Lg@   spacing= 0.05*@Lg@
line y location= 2*@Lg@     spacing= @Lg@       tag= right 

region Silicon xlo= top xhi= bottom ylo= left yhi= right 

## step Init
init concentration= @NWell@ field= Boron slice.angle= 180 !DelayFullD

pdbSet Silicon Dopant DiffModel ChargedFermi

#visualize
struct tdr= JH_n@node@_01_initialize !Gas !interfaces

#-----------------------------------------------------------------------
# step Gate Oxidation
#-----------------------------------------------------------------------
pdbSet Oxide Grid perp.add.dist 0.01e-4 
diffuse time= @GOxTime@ temperature= 950 O2

#visualize
struct tdr= JH_n@node@_02_gate_oxidation !Gas !interfaces

## step extract_tox
set oxidelayer [lindex [layers y=0 Oxide] 1]
puts "DOE: tox [format %.4f [expr [lindex $oxidelayer 1] - [lindex $oxidelayer 0]]]"

#-----------------------------------------------------------------------
# step Dual-Metal Gate Formation
# gate length = Lg
# source-side gate: -Lg/2 ~ -DMG_Gap/2
# drain-side gate : +DMG_Gap/2 ~ +Lg/2
#
# gateS : Titanium
# gateD : Tungsten
# Workfunction은 SDevice에서 설정
#-----------------------------------------------------------------------

## Source-side metal gate
deposit material= {Titanium} type= anisotropic thickness= 0.1

mask name= gateS left= -@Lg@/2 right= -@DMG_Gap@/2
etch material= {Titanium} type= anisotropic thickness= 0.12 mask= gateS

#visualize
struct tdr= JH_n@node@_03_gateS_formation !Gas !interfaces

## Drain-side metal gate
deposit material= {Tungsten} type= anisotropic thickness= 0.1

mask name= gateD left= @DMG_Gap@/2 right= @Lg@/2
etch material= {Tungsten} type= anisotropic thickness= 0.12 mask= gateD

#visualize
struct tdr= JH_n@node@_04_gateD_formation !Gas !interfaces

#-----------------------------------------------------------------------
# step Gate Oxide Etch
# gate 전체 영역은 보호하고, source/drain 영역의 oxide 제거
#-----------------------------------------------------------------------

mask name= gateAll left= -@Lg@/2 right= @Lg@/2
etch Oxide type= anisotropic thickness= 0.02 mask= gateAll

#visualize
struct tdr= JH_n@node@_05_gate_oxide_etch !Gas !interfaces

#-----------------------------------------------------------------------
# step Temporary Gate/Gap Implant-Block Cap
#
# 목적:
# gateS-gateD 사이 DMG_Gap으로 LDD/SD n-type dopant가 침투하는 것 방지.
#
# gateAll 영역(-Lg/2 ~ +Lg/2)에만 Nitride cap을 남기고,
# source/drain implant 영역은 열어둔다.
#-----------------------------------------------------------------------

deposit Nitride type= anisotropic thickness= 0.020

mask name= gateCap left= -@Lg@/2 right= @Lg@/2
etch Nitride type= anisotropic thickness= 0.030 mask= gateCap

#visualize
struct tdr= JH_n@node@_06_gate_gap_cap !Gas !interfaces

#-----------------------------------------------------------------------
# step LDD implant
# LDD_Dose만 Workbench 변수로 사용
# gate/gap 영역은 Nitride cap에 의해 implant-block 됨
#-----------------------------------------------------------------------
implant Arsenic dose= @LDD_Dose@ energy= @LDD_E@

#visualize
struct tdr= JH_n@node@_07_LDD_implant !Gas !interfaces

#-----------------------------------------------------------------------
# step Spacer formation
#
# 기존 spacer 공정은 유지하되,
# gateAll 영역의 temporary cap은 mask로 보호한다.
# source/drain 쪽의 수평 nitride는 제거되어 sidewall spacer가 형성됨.
#-----------------------------------------------------------------------
deposit Nitride type= isotropic thickness= 0.3*@Lg@

#visualize
struct tdr= JH_n@node@_08_spacer_depo !Gas !interfaces

etch Nitride type= anisotropic thickness= 0.35*@Lg@ mask= gateCap

#visualize
struct tdr= JH_n@node@_09_spacer_etch_cap_kept !Gas !interfaces

#-----------------------------------------------------------------------
# step SD Implant
# fixed SD_Dose / SD_Energy 사용
# gate/gap 영역은 여전히 Nitride cap에 의해 보호됨
#-----------------------------------------------------------------------
implant Phosphorus dose= @SD_Dose@ energy= @SD_E@

#visualize
struct tdr= JH_n@node@_10_SD_implant !Gas !interfaces

## step SD Anneal
diffuse time=0.5<s> temperature= 950

#visualize
struct tdr= JH_n@node@_11_SD_anneal !Gas !interfaces

#-----------------------------------------------------------------------
# step Remove Temporary Gate/Gap Cap
#
# 도핑과 anneal이 끝난 뒤 gateAll 위의 temporary Nitride cap 제거.
# source/drain 쪽 spacer는 최대한 유지하기 위해 outside 영역을 mask로 보호.
#-----------------------------------------------------------------------

mask name= keepOuterNitride segments= { -2*@Lg@ -@Lg@/2  @Lg@/2 2*@Lg@ }

set GateCapStripThick [expr 0.020 + 0.40*@Lg@]

etch Nitride type= anisotropic thickness= $GateCapStripThick mask= keepOuterNitride

#visualize
struct tdr= JH_n@node@_12_gate_cap_removed !Gas !interfaces

#-----------------------------------------------------------------------
# step contactSD
# source/drain contact metal
# gateS는 Titanium으로 바꿨지만, source/drain contact metal은 기존 Aluminum 유지
#-----------------------------------------------------------------------
deposit Aluminum type= anisotropic thickness= 0.05

# source side와 drain side Al만 남김
mask name= contact segments= { -2*@Lg@ -1.2*@Lg@  1.2*@Lg@ 2*@Lg@ }
etch Aluminum type= anisotropic thickness= 0.1 mask= contact 

#visualize
struct tdr= JH_n@node@_13_Al_contact !Gas !interfaces

#-----------------------------------------------------------------------
# No reflect
# Dual metal gate는 비대칭 구조이므로 transform reflect 사용하면 안 됨
#-----------------------------------------------------------------------

contact name= substrate bottom

contact name= source point y= -@Lg@*1.5 x= -0.010 replace
contact name= drain  point y=  @Lg@*1.5 x= -0.010 replace

## Dual gate contacts
contact name= gateS point y= -@Lg@*0.25 x= -0.050 replace
contact name= gateD point y=  @Lg@*0.25 x= -0.050 replace

## step save
struct tdr= n@node@ !Gas !interfaces
