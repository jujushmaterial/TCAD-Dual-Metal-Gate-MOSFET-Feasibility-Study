---
layout: default
title: Reproducibility and Full TCAD Source
---

# Reproducibility and Full TCAD Source

- [프로젝트 첫 페이지](../)
- [발표 흐름으로 정리한 전체 연구](../study/)
- [데이터 단계와 신뢰성](./data_lineage_and_reliability.html)
- [최종 발표자료](../presentation/)
- [코드 목록](../source/)

이 페이지는 발표자료의 각 연구 단계가 어떤 Sentaurus code set과 결과 데이터에 연결되는지 정리합니다.

---

## 1. Execution environment

- Synopsys Sentaurus T-2022.03
- Sentaurus Workbench
- SProcess
- SDevice
- SVisual
- Linux server accessed through MobaXterm

실행에는 유효한 Sentaurus license와 Workbench node/parameter 설정이 필요합니다.

```text
Workbench variables
→ SProcess structure generation
→ TDR checkpoint inspection
→ SDevice Low-Vd / High-Vd simulation
→ Id–Vg and Ig–Vg output
→ SVisual metric extraction
→ DOE scalar comparison
→ portfolio CSV and figures
```

---

## 2. Code sets

| Code set | Purpose | Status |
|---|---|---|
| [Presentation-stage DMG code](https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/tree/main/source/coursework) | Lateral GateS/GateD 구현과 scaling 검증 | Final presentation baseline |
| [SiO₂ gate-leakage code](https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/tree/main/source/verified/sio2_ig_baseline) | GateS/GateD tunneling current 추출 | Verified successful run |
| [High-K and gate-ratio code](https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/tree/main/source/verified/highk_eot1p6_gate_ratio) | High-K, ratio, corrected Vtgm, CC-DIBL | Main verified set |
| [Variable-EOT extension](https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/tree/main/source/extended/highk_eot_sweep) | EOT-dependent HfO₂ thickness | Successful extension |

---

## 3. Main Workbench variables

### Geometry and process

- `Lg`
- `DMG_Gap`
- `DMG_RatioS`
- `NWell`
- `GOxTime`
- `LDD_Dose`
- `LDD_E`
- `SD_Dose`
- `SD_E`

### Electrical conditions

- `Wf_S`
- `Wf_D`
- `Vd_Low`
- `Vd_High`

### Extended High-K study

- `EOT_Target`

---

## 4. Presentation-stage DMG code

### Files

- [SProcess command](https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/blob/main/source/coursework/sprocess_lg0p1_initial.cmd)
- [SDevice command](https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/blob/main/source/coursework/sdevice_initial.cmd)
- [SVisual command](https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/blob/main/source/coursework/svisual_initial.tcl)

### Purpose

- GateS/GateD lateral structure formation
- independent work-function assignment
- Low-Vd and High-Vd Id–Vg sweep
- Vtgm, SS, gm, Ion, Ioff, Ion/Ioff and initial DIBL extraction
- Workbench DOE scalar output

### Known limitations

- gate tunneling 미포함
- High-K 미포함
- corrected Vtgm 및 constant-current threshold 미포함

이 코드는 사용자가 보관한 SProcess, SDevice, SVisual command 문서와 대조했으며, 저장소에 축약돼 있던 SVisual은 발표 단계 전문으로 복원했습니다.

---

## 5. SiO₂ gate-leakage code

### Files

- [SProcess](https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/blob/main/source/verified/sio2_ig_baseline/sprocess.cmd)
- [SDevice](https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/blob/main/source/verified/sio2_ig_baseline/sdevice.cmd)
- [SVisual](https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/blob/main/source/verified/sio2_ig_baseline/svisual.tcl)
- [Parameter file](https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/blob/main/source/verified/sio2_ig_baseline/sdevice.par)

### Expected outputs

- standard Id metrics
- `IgS`
- `IgD`
- `IgTotal`

### Related result

- [SiO₂ gate-leakage CSV](https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/blob/main/results/sio2_gate_leakage.csv)
- [Gate-leakage section](../study/#8-추가-문제-발견-thin-sio₂-gate-leakage)

---

## 6. High-K and gate-ratio verified code

### Files

- [SProcess](https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/blob/main/source/verified/highk_eot1p6_gate_ratio/sprocess.cmd)
- [SDevice](https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/blob/main/source/verified/highk_eot1p6_gate_ratio/sdevice.cmd)
- [SVisual](https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/blob/main/source/verified/highk_eot1p6_gate_ratio/svisual.tcl)
- [Parameter file](https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/blob/main/source/verified/highk_eot1p6_gate_ratio/sdevice.par)

### Main features

- SiO₂ interfacial layer 0.5 nm
- HfO₂ 5.64 nm
- EOT 약 1.6 nm
- normalized `DMG_RatioS`
- GateS/GateD NonLocal tunneling
- corrected Vtgm with `−Vd/2`
- CC1 and CC2 constant-current threshold
- threshold crossing valid flag
- signed and absolute DIBL

### Related results

- [High-K comparison CSV](https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/blob/main/results/high_k_comparison.csv)
- [Gate-ratio trade-off CSV](https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/blob/main/results/gate_ratio_tradeoff.csv)

### Known limitations

- 2D planar concept model
- High-K absolute leakage calibration 미완료
- GAA·CFET 3D geometry 미포함
- process variability와 quantum confinement 미포함

---

## 7. Variable-EOT extension

- [SProcess](https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/blob/main/source/extended/highk_eot_sweep/sprocess.cmd)
- [Parameter file](https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/blob/main/source/extended/highk_eot_sweep/sdevice.par)

`EOT_Target`에서 HfO₂ physical thickness를 계산해 1.6, 1.2, 1.0 nm 등의 후속 sweep을 수행하기 위한 확장입니다. SDevice와 SVisual은 verified High-K code를 재사용합니다.

---

## 8. Result files

| File | Content |
|---|---|
| [Scaling baseline](https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/blob/main/results/scaling_baseline.csv) | 세 gate length의 Single–Dual baseline |
| [Selected conditions](https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/blob/main/results/scaling_selected_conditions.csv) | scale별 parameter-screening selected conditions |
| [SiO₂ gate leakage](https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/blob/main/results/sio2_gate_leakage.csv) | leakage-follow-up Id/Ig data |
| [High-K comparison](https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/blob/main/results/high_k_comparison.csv) | same-EOT SiO₂–High-K comparison |
| [Gate-ratio trade-off](https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/blob/main/results/gate_ratio_tradeoff.csv) | GateS/GateD ratio raw comparison |

각 데이터의 단계와 혼합 금지 원칙은 [Data Lineage](./data_lineage_and_reliability.html)에 기록했습니다.

---

## 9. Reproducibility boundary

동일 수치의 완전한 재현은 다음 요소에 영향을 받을 수 있습니다.

- Sentaurus version and material database
- license option
- Workbench node dependency and parameter registration
- mesh and numerical environment
- input/output naming convention

따라서 이 저장소는 연구 구현 논리, code structure, process sequence, metric extraction method, selected data provenance와 known limitation을 재현 가능하게 공개하는 데 초점을 둡니다.

## AI assistance disclosure

OpenAI ChatGPT는 command 초안·수정, debugging 방향, metric-extraction logic, EOT 계산, 데이터 비교와 문서 구조화를 보조했습니다. 성공 여부와 최종 해석은 Sentaurus Workbench에서 직접 실행한 log, TDR, curve와 DOE output을 기준으로 판단했습니다.
