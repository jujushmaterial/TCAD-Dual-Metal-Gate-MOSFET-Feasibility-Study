# High-K Variable-EOT Sweep

EOT target을 1.6, 1.2, 1.0 nm 등으로 확장할 수 있도록 HfO₂ physical thickness를 자동 계산한 성공 extension입니다.

## Files

- [`sprocess.cmd`](./sprocess.cmd): `EOT_Target`에서 HfO₂ physical thickness를 계산하는 전체 SProcess code
- [`sdevice.par`](./sdevice.par): SiO₂ IL/HfO₂ tunneling parameter
- [SDevice code](../../verified/highk_eot1p6_gate_ratio/sdevice.cmd): fixed-EOT 실험과 동일한 verified SDevice code 사용
- [SVisual code](../../verified/highk_eot1p6_gate_ratio/svisual.tcl): corrected Vtgm, CC-DIBL, Id/Ig extraction code 사용

SDevice와 SVisual은 EOT에 독립적이며 verified fixed-EOT code와 동일한 logic을 사용하므로 중복 파일 대신 원본 verified code에 연결했습니다.

이 확장은 후속 연구 자산이며, 최종 학회 발표의 핵심 결과는 EOT ≈ 1.6 nm 조건을 사용했습니다.
