# Auto Screenshot Plugin

Windows에서 Claude Code 세션 중 자동으로 활성 창 스크린샷을 촬영하는 플러그인입니다.

## 기능

- **SessionStart**: 세션 시작 시 스크린샷 저장 폴더 생성 (기본 활성화)
- **UserPromptSubmit**: 사용자가 프롬프트를 제출할 때 스크린샷 촬영
- **PostToolUse (Bash)**: Bash 명령 실행 후 스크린샷 촬영
- **SessionEnd**: 세션 종료 시 로그 기록

## 슬래시 커맨드

| 커맨드 | 설명 |
|--------|------|
| `/start-screenshot` | 스크린샷 캡처 활성화 |
| `/stop-screenshot` | 스크린샷 캡처 비활성화 |

스크린샷 활성화 상태는 `C:\Screenshots\.screenshot_enabled` 파일로 관리됩니다.
- 파일 존재 = 활성화
- 파일 없음 = 비활성화

## 스크린샷 저장 위치

- 기본 경로: `C:\Screenshots`
- 세션별 폴더: `C:\Screenshots\<session_id>\`
- 파일명 형식: `screenshot_yyyyMMdd_HHmmss_fff.jpg`

## 요구사항

- Windows OS
- PowerShell (기본 설치됨)

## 설치

### 마켓플레이스를 통한 설치 (권장)

```bash
# 마켓플레이스 추가
/plugin marketplace add username/my-claude-plugins

# 플러그인 설치
/plugin install auto-screenshot@my-claude-plugins
```

### 로컬 설치

이 플러그인이 포함된 프로젝트에서 Claude Code를 실행하면 자동으로 활성화됩니다.

또는 다음 명령으로 플러그인 디렉토리를 지정하여 사용:
```bash
claude --plugin-dir /path/to/screenshot-hooks/.claude-plugin
```

## 파일 구조

```
.claude-plugin/
├── plugin.json             # 플러그인 매니페스트
├── README.md               # 이 파일
├── commands/
│   ├── start-screenshot.md # 스크린샷 활성화 커맨드
│   └── stop-screenshot.md  # 스크린샷 비활성화 커맨드
└── hooks/
    ├── hooks.json          # 훅 설정
    ├── session_start.ps1   # 세션 시작 스크립트
    ├── capture_screen.ps1  # 스크린샷 캡처 스크립트
    └── session_end.ps1     # 세션 종료 스크립트
```

## 로그

세션 로그는 `C:\Screenshots\_session_log.txt`에 기록됩니다.

## 라이선스

MIT License - 자유롭게 사용, 수정, 배포할 수 있습니다.
