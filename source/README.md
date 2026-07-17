# TCAD Source Code

프로젝트에서 사용한 Sentaurus command 전문을 발전 단계별로 공개합니다.

## Structure

- [`coursework/`](./coursework/): 최초 수업 프로젝트 구현본
- [`verified/sio2_ig_baseline/`](./verified/sio2_ig_baseline/): SiO₂ DMG와 gate tunneling
- [`verified/highk_eot1p6_gate_ratio/`](./verified/highk_eot1p6_gate_ratio/): 학회 발표의 High-K·ratio·corrected DIBL 코드
- [`extended/highk_eot_sweep/`](./extended/highk_eot_sweep/): 후속 EOT sweep 확장본

각 폴더에는 SProcess, SDevice, SVisual과 필요한 parameter file이 포함됩니다. 실행에는 Synopsys Sentaurus T-2022.03 환경과 Workbench parameter/node 설정이 필요합니다.
