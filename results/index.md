---
layout: default
title: Results and Data
---

# Results and Data

- [프로젝트 첫 페이지](../)
- [발표 흐름으로 정리한 전체 연구](../study/)
- [데이터 단계와 DIBL 신뢰성](../appendix/data_lineage_and_reliability.html)
- [최적화 과정 상세](../appendix/optimization_details.html)

결과 파일은 연구 단계가 서로 섞이지 않도록 분리했습니다.

| File | Stage | Description |
|---|---|---|
| [Scaling baseline CSV](https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/blob/main/results/scaling_baseline.csv) | A | 0.25/0.10/0.028 μm Single–Dual baseline |
| [Selected conditions CSV](https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/blob/main/results/scaling_selected_conditions.csv) | B | Scale별 parameter-screening selected conditions |
| [SiO₂ gate leakage CSV](https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/blob/main/results/sio2_gate_leakage.csv) | C | Leakage-follow-up Id/Ig data |
| [High-K comparison CSV](https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/blob/main/results/high_k_comparison.csv) | D | Same-EOT SiO₂ and SiO₂ IL/HfO₂ comparison |
| [Gate-ratio trade-off CSV](https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/blob/main/results/gate_ratio_tradeoff.csv) | E | 6:4–3.5:6.5 ratio raw data |

## Data policy

- 발표 15장의 scaling-stage 0.028 μm 값과 발표 17장의 leakage-follow-up 값을 같은 unchanged condition으로 합치지 않습니다.
- 초기 발표 DIBL을 corrected extraction 결과로 소급 교체하지 않습니다.
- low-confidence DIBL outlier를 명시합니다.
- High-K Ig는 calibrated absolute prediction이 아니라 동일 framework 안의 relative first-pass comparison입니다.
- Gate-ratio 5:5는 global optimum이 아니라 balanced reference condition입니다.

각 stage의 조건과 extraction 신뢰성은 [Data Lineage and DIBL Reliability](../appendix/data_lineage_and_reliability.html)에 정리했습니다.
