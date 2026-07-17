# TCAD Dual-Metal-Gate MOSFET Feasibility Study

2D planar nMOS TCAD test vehicle에서 **source–drain 방향 Work-Function Split**의 물리적 효과를 검증하고, parameter screening, gate leakage, High-K gate stack과 GateS/GateD ratio trade-off를 분석한 연구입니다.

이 프로젝트는 생산 가능한 planar DMG 공정이나 단일 절대 최적값을 주장하지 않습니다. 복잡한 GAA·CFET 구조로 확장하기 전, 서로 다른 work function의 역할을 단순한 2D 구조에서 분리해 확인한 **feasibility and comparative study**입니다.

**Summary:**  
This conference-presented study uses a 2D Sentaurus TCAD test vehicle to examine lateral work-function splitting, process-parameter screening, high-k gate-leakage mitigation, and GateS/GateD ratio trade-offs.

## Start Here

| Resource | Description |
|---|---|
| [Project Page](https://jujushmaterial.github.io/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/) | 핵심 연구 흐름과 결과 요약 |
| [Full Study](https://jujushmaterial.github.io/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/study/) | 최종 발표 순서로 읽는 전체 연구 |
| [Final Presentation PDF](./presentation/final_conference_presentation.pdf) | 26장 최종 학회 발표자료 |
| [Original PPTX](./presentation/final_conference_presentation.pptx) | 원본 발표파일 |
| [Optimization Details](./appendix/optimization_details.md) | 0.25/0.10/0.028 μm parameter screening과 선정 과정 |
| [Data Lineage and Reliability](./appendix/data_lineage_and_reliability.md) | 데이터 단계 구분과 DIBL 신뢰성 |
| [Reproducibility](./appendix/reproducibility.md) | 코드 세트, 실행 순서와 재현 범위 |
| [Full TCAD Source](./source/index.md) | SProcess, SDevice, SVisual, parameter files |
| [Results](./results/index.md) | 공개 CSV와 데이터 정책 |
| [References](./references/bibliography.md) | DOI, 공식 링크와 연구 내 역할 |

## Research Flow

```text
Work-Function Engineering 필요성
→ DMG 가설 설정
→ SProcess/SDevice/SVisual 구현
→ Lg 0.25 / 0.10 / 0.028 μm 검증과 parameter screening
→ DIBL extraction 신뢰성 문제 발견
→ Thin-SiO₂ gate leakage 확인
→ 동일 EOT의 SiO₂ IL/HfO₂ 적용
→ GateS/GateD ratio trade-off
→ 한계와 GAA·CFET 후속 연구 질문
```

## Research at a Glance

| Item | Description |
|---|---|
| Tool | Synopsys Sentaurus T-2022.03: Workbench, SProcess, SDevice, SVisual |
| Device | 2D planar nMOS test vehicle |
| Gate configuration | GateS 4.2 eV / GateD 4.8 eV |
| Scaling study | Lg = 0.25, 0.10, 0.028 μm |
| Parameter screening | NWell, LDD dose/energy, Source/Drain dose/energy |
| Gate stack extension | SiO₂ 1.6 nm → SiO₂ IL 0.5 nm + HfO₂ 5.64 nm |
| Gate-ratio study | GateS:GateD = 6:4, 5:5, 4.5:5.5, 3.5:6.5 |
| Main metrics | DIBL, SS, Ion, Ioff, Ion/Ioff, Ig |
| Team | 이선재, 주상현 |

## Main Findings

- 세 gate length에서 DMG는 Ion을 일부 낮추는 대신 Ioff와 Ion/Ioff를 개선하는 방향을 반복적으로 보였습니다.
- NWell, LDD와 Source/Drain 조건을 screening해 scale별 representative condition을 선정했습니다.
- 초기 Vtgm 기반 DIBL 특이값을 발견하고, 발표 이후 corrected Vtgm과 constant-current threshold를 추가했습니다.
- 동일 EOT의 SiO₂ IL/HfO₂ stack에서 대표 High-Vd 조건의 `IgTotal_On`이 약 99.40% 감소했습니다.
- Drain-side high-WF gate 비율이 증가하면 Ioff·SS·Ig는 개선되는 방향을 보였지만 Ion은 소폭 감소하고 DIBL은 비단조적으로 변했습니다.
- 5:5는 global optimum이 아니라 balanced reference condition으로 해석했습니다.

## Code Organization

```text
source/
├── coursework/                         # 최초 수업 구현본
├── verified/sio2_ig_baseline/          # SiO₂ DMG + gate tunneling
├── verified/highk_eot1p6_gate_ratio/   # High-K + ratio + reliable DIBL
└── extended/highk_eot_sweep/           # 후속 variable-EOT extension
```

각 폴더에서 프로젝트에 사용한 Sentaurus command 전문을 확인할 수 있습니다.

## Data Policy

- 발표 13~16장의 scaling data와 발표 17장의 leakage-follow-up data를 동일 unchanged condition으로 합치지 않습니다.
- 초기 발표 DIBL을 corrected extraction 결과처럼 덮어쓰지 않습니다.
- low-confidence outlier를 명시합니다.
- High-K tunneling 결과는 calibrated absolute prediction이 아니라 first-pass relative comparison입니다.
- GAA·CFET 적용은 후속 연구 방향이며 본 연구의 직접 simulation 결과가 아닙니다.

## AI Assistance Disclosure

OpenAI ChatGPT는 code 초안·수정, debugging 방향, metric-extraction logic, 계산, 결과 비교, 발표와 포트폴리오 구조화를 보조했습니다. 모든 command는 Sentaurus Workbench에서 직접 실행해 log, TDR, curve와 DOE output을 확인했으며, 최종 데이터 선택과 해석 범위는 연구 참여자가 검토했습니다.
