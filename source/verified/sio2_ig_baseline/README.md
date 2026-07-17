# SiO₂ DMG + Gate Leakage Baseline

기존 SiO₂ 약 1.6 nm DMG structure에서 gate tunneling current를 추가 추출한 성공 code set입니다.

## Files

- `sprocess.cmd`: DMG structure, temporary gate/gap cap, TDR checkpoints
- `sdevice.cmd`: Low/High-Vd sweep and gateS/gateD NonLocal tunneling
- `svisual.tcl`: Id and gate-terminal current extraction
- `sdevice.par`: SiO₂ tunneling parameter

## Expected Outputs

Vtgm, SS, gm, Ion, Ioff, Ion/Ioff, DIBL, IgS, IgD, IgTotal and total off-leakage estimate.
