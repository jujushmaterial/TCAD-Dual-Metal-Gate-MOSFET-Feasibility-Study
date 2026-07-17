# Presentation-Stage DMG Code Set

최종 발표의 scaling 및 parameter-screening 단계에서 사용한 기본 Dual-Metal Gate SProcess–SDevice–SVisual 코드 세트입니다.

## Files

- [`sprocess_lg0p1_initial.cmd`](./sprocess_lg0p1_initial.cmd)  
  GateS/GateD 형성, DMG gap, temporary implant-block cap, LDD/Source-Drain implant, anneal, cap removal과 contact 구현
- [`sdevice_initial.cmd`](./sdevice_initial.cmd)  
  GateS/GateD independent work function, Low-Vd/High-Vd Id–Vg sweep
- [`svisual_initial.tcl`](./svisual_initial.tcl)  
  Low/High-Vd curve loading, Vtgm, SS, gm, Ion, Ioff, Ion/Ioff, DIBL extraction과 Workbench DOE scalar 출력

## Required Workbench variables

- `Lg`
- `NWell`
- `GOxTime`
- `LDD_Dose`
- `LDD_E`
- `SD_Dose`
- `SD_E`
- `DMG_Gap`
- `Wf_S`
- `Wf_D`
- `Vd_Low`
- `Vd_High`

## Execution order

```text
SProcess
→ n@node@ TDR structure
→ SDevice Low/High-Vd Id–Vg
→ SVisual metric extraction
```

이 세트는 사용자가 보관한 최종 SProcess, SDevice, SVisual command 문서와 대조해 전문을 복원한 발표 단계 코드입니다.

Gate tunneling, High-K stack, gate-ratio parameterization, corrected Vtgm과 constant-current DIBL은 `source/verified/`의 후속 코드 세트에서 확인할 수 있습니다.
