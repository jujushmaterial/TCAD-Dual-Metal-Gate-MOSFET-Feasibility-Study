---
layout: default
title: TCAD Source Code
---

# TCAD Source Code

프로젝트에서 사용한 Sentaurus command 전문을 연구 발전 단계별로 공개합니다.

- [프로젝트 첫 페이지](../)
- [발표 흐름으로 정리한 전체 연구](../study/)
- [실행 순서와 재현 범위](../appendix/reproducibility.html)
- [결과 데이터](../results/)

---

## 1. 최종 발표의 기본 DMG 코드 세트

최종 발표의 scaling 및 parameter-screening 단계에서 사용한 기본 SProcess–SDevice–SVisual 흐름입니다.

- [SProcess: lateral DMG 공정 구현](https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/blob/main/source/coursework/sprocess_lg0p1_initial.cmd)
- [SDevice: Low/High-Vd Id–Vg sweep](https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/blob/main/source/coursework/sdevice_initial.cmd)
- [SVisual: Vth, SS, Ion, Ioff, Ion/Ioff, DIBL extraction](https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/blob/main/source/coursework/svisual_initial.tcl)
- [기본 코드 폴더 전체 보기](https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/tree/main/source/coursework)

이 세 파일은 서로 같은 Workbench project에서 순서대로 사용되는 한 세트입니다.

```text
SProcess
→ TDR structure
→ SDevice Low/High-Vd Id–Vg
→ SVisual metric extraction
```

---

## 2. SiO₂ gate-leakage baseline

GateS와 GateD terminal current를 분리하고 gate tunneling을 비교한 코드 세트입니다.

- [SiO₂ leakage 코드 폴더](https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/tree/main/source/verified/sio2_ig_baseline)

주요 추가 기능:

- GateS/GateD current extraction
- `IgTotal = |IgS| + |IgD|`
- Low-Vd/High-Vd gate-current 비교
- Thin-SiO₂ leakage 확인

---

## 3. High-K EOT 1.6 nm 및 gate-ratio 분석

High-K stack, GateS/GateD ratio parameterization, corrected Vtgm과 constant-current DIBL을 포함한 주 검증 세트입니다.

- [High-K 및 gate-ratio 코드 폴더](https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/tree/main/source/verified/highk_eot1p6_gate_ratio)

주요 추가 기능:

- SiO₂ interfacial layer/HfO₂ stack
- EOT 약 1.6 nm 유지
- GateS/GateD 길이 비율 parameterization
- GateS/GateD별 NonLocal tunneling mesh
- corrected Vtgm
- constant-current Vth
- signed/absolute DIBL과 valid flag

---

## 4. Variable-EOT extension

HfO₂ 두께를 EOT 목표값에 맞춰 계산하는 확장 세트입니다.

- [Variable-EOT 코드 폴더](https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/tree/main/source/extended/highk_eot_sweep)

이 세트는 verified High-K SDevice/SVisual을 재사용하고, SProcess와 parameter file에서 EOT-dependent physical thickness를 변경합니다.

---

## 공개 범위와 한계

공개된 코드는 프로젝트에서 실제 사용한 representative command 전문입니다. 동일한 절대값 재현에는 다음 조건이 필요합니다.

- Synopsys Sentaurus T-2022.03
- 유효한 license와 server environment
- 동일한 Workbench variable 등록
- 동일한 node dependency와 file prefix
- mesh, material parameter와 tunneling model 설정

코드와 결과의 정확한 연결은 [재현 방법과 코드 매핑](../appendix/reproducibility.html)에서 확인할 수 있습니다.
