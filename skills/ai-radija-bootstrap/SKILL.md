---
name: ai-radija-bootstrap
description: Entrevista al desarrollador para definir el stack tecnológico de un proyecto nuevo (cualquier país y cualquier stack), genera el contrato CLAUDE.md + ADR de selección + scaffold funcional acorde al stack elegido. Aplica reglas irrompibles transversales (secrets en vault, idioma inglés en código, UTC, soft delete, no exponer entidades, hash fuerte de PINs) y reglas regulatorias por país (LFPDPPP en MX, LGPD en BR, Ley 1581 en CO, Ley 25.326 en AR, Ley 19.628 en CL, Ley 29.733 en PE, LOPDP en EC, Ley 172-13 en DO/PR). Bloquea combinaciones de stack que rompen política y exige justificación documentada en el ADR. Usar al iniciar un proyecto greenfield cuyo stack aún no esté definido, o al documentar el stack de un proyecto existente.
---

# Radija Bootstrap

> Skill de bootstrap de stack para proyectos nuevos. Entrevista al desarrollador, valida el stack contra una matriz de políticas, genera el contrato `CLAUDE.md`, el ADR de selección y un scaffold funcional para el stack elegido.

---

## 🎯 Cuándo invocar este skill

| Situación | Skill correcto |
|---|---|
| Proyecto greenfield, stack libre | **`ai-radija-bootstrap`** (este) |
| Proyecto existente sin `CLAUDE.md` | **`ai-radija-bootstrap`** (este) |
| País de operación: MX / CO / AR / CL / PE / EC / BR / DO / PR / Regional | **`ai-radija-bootstrap`** (este) |

---

## 🔄 Flujo del skill (orden estricto)

```
1. Bloque 1 — Identidad del proyecto         (AskUserQuestion)
2. Bloque 2 — Stack runtime                  (AskUserQuestion)
3. Bloque 3 — Infraestructura                (AskUserQuestion)
4. Bloque 4 — Testing                        (AskUserQuestion)
5. Motor de política — evaluar violations
   - Si "Bloquear duro" → terminar pidiendo cambio
   - Si "Bloquear blando" → AskUserQuestion campo libre de justificación
6. Generar archivos en el repo
   - CLAUDE.md (raíz)
   - docs/architecture-decisions/ADR-0001-stack-selection.md
   - Scaffold backend + frontend según elección
   - database/migrations/V001__Create_Tables.sql
   - infra/pipeline (Azure DevOps o GitHub Actions)
   - .gitignore + README.md
7. Mensaje final: sugerir /speckit.constitution y /speckit.specify
```

---

## 📋 Bloque 1 — Identidad del proyecto (4 preguntas)

Llamar a `AskUserQuestion` con estas 4 preguntas en una sola invocación:

| # | Header | Pregunta | Opciones |
|---|---|---|---|
| 1 | País | ¿En qué país opera el proyecto? | México, Colombia, Argentina, Chile, Perú, Ecuador, Brasil, RD, PR, Regional |
| 2 | Tipo | ¿Qué tipo de proyecto es? | Web full-stack (Recomendado), API-only, Microservicio, Mobile, Batch/ETL, Integración |
| 3 | Idioma UI | ¿En qué idioma se mostrará la UI al usuario final? | Español (Recomendado), Portugués BR, Bilingüe ES+PT, Otro |
| 4 | Prefijo | ¿Cuál es el `AppPrefix` para tablas y SPs? | Texto libre (ej: `AIHub`, `MyApp`) |

> Para la pregunta 4, usar `AskUserQuestion` con dos opciones predefinidas comunes y "Otro" — o pedirla por separado como texto libre si el usuario prefiere.

---

## 📋 Bloque 2 — Stack runtime (4 preguntas)

| # | Header | Pregunta | Opciones (default marcado "Recomendado") |
|---|---|---|---|
| 5 | Frontend | ¿Qué framework de frontend usarás? | **Angular 17+ (Recomendado)**, React 18+, Vue 3, Blazor, Ninguno |
| 6 | Backend | ¿Qué stack de backend usarás? | **ASP.NET Core .NET 9 (Recomendado)**, Node.js + NestJS, Java + Spring Boot 3, Python + FastAPI, Go + chi |
| 7 | DB+ORM | ¿Base de datos y acceso a datos? | **Azure SQL + Dapper + SPs (Recomendado)**, PostgreSQL + ORM, MySQL + ORM, Cosmos DB, Oracle + SPs |
| 8 | Auth | ¿Mecanismo de autenticación? | **Azure AD + MSAL (Recomendado)**, Azure AD B2C, Okta, Auth0, JWT propio |

---

## 📋 Bloque 3 — Infraestructura (3 preguntas)

| # | Header | Pregunta | Opciones |
|---|---|---|---|
| 9 | Hosting | ¿Dónde se despliega? | **Azure App Service (Recomendado)**, AKS, Container Apps, Azure Functions, On-premises |
| 10 | CI/CD | ¿Plataforma de CI/CD? | **Azure DevOps Pipelines (Recomendado)**, GitHub Actions, GitLab CI |
| 11 | Vault+Obs | ¿Vault y observabilidad? | **Azure Key Vault + App Insights (Recomendado)**, HashiCorp Vault + Datadog, AWS Secrets Manager + ELK, Otro |

---

## 📋 Bloque 4 — Testing (1 pregunta agrupada)

Pre-rellenar opciones según stack del Bloque 2. Por ejemplo si Backend=.NET y Frontend=Angular:

| Header | Pregunta | Opciones |
|---|---|---|
| Testing | Confirma frameworks de test y cobertura objetivo | **xUnit+Moq (70%) + Jasmine+Karma (60%) [Recomendado]**, Otro setup |

---

## 🚨 Motor de política — Tabla de validación

Tras recoger las 12 respuestas, evaluar cada fila contra esta matriz. Si alguna activa, ejecutar la acción indicada antes de generar archivos.

| Condición detectada | Acción | Razón |
|---|---|---|
| Auth ∉ {Azure AD, Azure AD B2C, Okta} | **Bloquear blando** — pedir justificación | Estándar SSO corporativo |
| Vault = "Otro" sin proveedor claro, o secrets en repo | **Bloquear duro** — rehusar generar | Política irrompible: secrets jamás en repo |
| Hosting = "On-premises" Y País = Brasil | **Bloquear blando** — exigir DPO sign-off | LGPD residencia regional |
| Observabilidad = "ninguna" | **Bloquear blando** — pedir justificación | Soporte oncall sin telemetría es inviable |
| ORM = EF Core + DB = Azure SQL | **Bloquear blando (warning)** — pedir justificación | Dapper+SPs es el estándar recomendado; EF requiere razonamiento |
| Idioma código ≠ inglés | **Bloquear blando** — pedir justificación | Estándar global de código |
| Frontend sin auth interceptor (no aplica si Frontend=Ninguno) | **Bloquear duro** — el scaffold lo incluye obligatorio | Riesgo de filtración de tokens |
| País ∈ {BR, MX, CO} + hosting fuera de la región del país | **Bloquear blando** — pedir justificación | Residencia de datos |

**Mecánica:**
- **Bloquear blando** → llamar a `AskUserQuestion` con una sola pregunta de texto libre. El texto del dev se inserta en el ADR bajo "Desviaciones del estándar".
- **Bloquear duro** → terminar el flujo con un mensaje claro: qué política se viola, qué debe cambiar, y ofrecer reabrir la entrevista en esa pregunta.

---

## 🔒 Reglas irrompibles transversales (aplican a CUALQUIER stack)

Estas reglas se replican en el `CLAUDE.md` generado y se aplican en el scaffold:

1. **Secrets** nunca en repo, siempre en vault del proveedor elegido.
2. **Idioma del código**: inglés (no negociable). Variables, métodos, clases, comentarios técnicos.
3. **Idioma de UI**: el elegido en Bloque 1.
4. **Zona horaria**: backend siempre en UTC; conversión a local en frontend.
5. **Soft delete**: `IsActive` / `is_active` / `deleted_at` — nunca DELETE físico.
6. **Auditoría obligatoria** en toda tabla: `CreatedAt`, `UpdatedAt`, `CreatedBy`, `UpdatedBy`.
7. **No exponer entidades** de dominio en endpoints — siempre DTO/ViewModel/Response model.
8. **Wrapper de respuesta API**: `ApiResponse<T> { success, data, error, message }` adaptado al lenguaje.
9. **CORS** restringido a dominios corporativos.
10. **Logs estructurados**, sin PII en claro, con correlation ID por request.
11. **Hash de PINs/passwords**: Argon2id o bcrypt; SHA-256 solo con salt único por registro.
12. **Rate limiting** en endpoints públicos y de IA.
13. **No exponer stack traces** en respuestas de producción.
14. **Validación en boundary** (DTOs de entrada) — no confiar en clientes.

---

## 🌎 Reglas regulatorias por país

Cada país tiene su archivo en [`templates/regulations/`](./templates/regulations/). Incluir en el `CLAUDE.md` generado **solo la sección del país elegido**:

| País | Marco | Archivo |
|---|---|---|
| México | LFPDPPP + INAI | [`mx-lfpdppp.md`](./templates/regulations/mx-lfpdppp.md) |
| Colombia | Ley 1581 + Decreto 1377 | [`co-ley1581.md`](./templates/regulations/co-ley1581.md) |
| Argentina | Ley 25.326 | [`ar-ley25326.md`](./templates/regulations/ar-ley25326.md) |
| Chile | Ley 19.628 + Ley 21.719 (vigencia 2026) | [`cl-ley19628.md`](./templates/regulations/cl-ley19628.md) |
| Perú | Ley 29.733 | [`pe-ley29733.md`](./templates/regulations/pe-ley29733.md) |
| Ecuador | LOPDP | [`ec-lopdp.md`](./templates/regulations/ec-lopdp.md) |
| Brasil | LGPD | [`br-lgpd.md`](./templates/regulations/br-lgpd.md) |
| RD / PR | Ley 172-13 / GLBA+HIPAA | [`do-pr-ley17213.md`](./templates/regulations/do-pr-ley17213.md) |

---

## 📦 Outputs a generar en el repo del proyecto

Tras la entrevista (y resolución de bloqueos), generar:

```
{repo-root}/
├── CLAUDE.md                                         ← contrato del proyecto (clave para futuras sesiones)
├── README.md                                         ← setup local
├── .gitignore                                        ← acorde a stacks elegidos
├── docs/
│   └── architecture-decisions/
│       └── ADR-0001-stack-selection.md               ← justificación + desviaciones
├── src/
│   ├── {AppPrefix}.API/                              ← scaffold backend ([`templates/scaffolds/<backend>/`](./templates/scaffolds/))
│   └── {AppPrefix}.Web/                              ← scaffold frontend (si aplica)
├── database/
│   └── migrations/
│       └── V001__Create_Tables.sql                   ← tabla ejemplo con auditoría
├── tests/
│   └── ...                                           ← skeleton de tests por stack
└── infra/
    └── {azure-pipelines.yml | .github/workflows/ci.yml | .gitlab-ci.yml}
```

**Importante:** los archivos del scaffold se copian desde `templates/scaffolds/<elegido>/` reemplazando placeholders:
- `{{ProjectName}}` → nombre de proyecto del dev
- `{{AppPrefix}}` → respuesta pregunta 4
- `{{Country}}` → respuesta pregunta 1
- `{{UILanguage}}` → respuesta pregunta 3

---

## 🎬 Mensaje final del skill

Tras generar archivos:

```
✅ Contrato técnico generado en {repo}/CLAUDE.md
✅ ADR-0001 registra {N} desviaciones del estándar
✅ Scaffold {backend} + {frontend} listo en src/

Próximos pasos sugeridos:
  1. Revisar CLAUDE.md y ajustar el AppPrefix/naming si hace falta
  2. Ejecutar /speckit.constitution para fijar principios del proyecto
  3. Ejecutar /speckit.specify para describir tu primera feature
  4. Instalar dependencias del stack (npm i / dotnet restore / etc.)
```

---

## 🧪 Cómo verificar este skill

Camino feliz:
1. Repo vacío de prueba.
2. "Iniciemos un proyecto Colombia API microservicio."
3. El skill debe ser sugerido. Aceptar defaults → scaffold .NET + Angular + Azure SQL.
4. Probar bloqueo blando: Auth=JWT propio → debe pedir justificación.
5. Probar bloqueo duro: Vault=ninguno → debe rehusar.
6. Probar regulatorio: País=Brasil + Hosting=on-prem → debe pedir DPO sign-off.
