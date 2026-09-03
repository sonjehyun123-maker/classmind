# ERD

## 데이터베이스

Supabase PostgreSQL 사용

## 테이블

* profiles
* courses
* sessions
* notes
* chat_messages

## 관계

```text
profiles
   │
   └── courses
          │
          └── sessions
                  │
                  ├── notes
                  └── chat_messages
```

## Storage

* PDF 저장
* 추후 이미지 저장 가능
