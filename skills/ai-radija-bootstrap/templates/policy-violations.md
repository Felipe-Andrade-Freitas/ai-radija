# Catálogo de violaciones de política

> El motor de política del skill `ai-radija-bootstrap` evalúa cada respuesta de la entrevista contra esta tabla. Si una fila aplica, ejecuta la acción.

## Tabla de validación

| ID | Condición | Acción | Razón | Mensaje al desarrollador |
|---|---|---|---|---|
| P01 | `Auth ∉ {Azure AD, Azure AD B2C, Okta}` | **Bloquear blando** | SSO corporativo estándar es Azure AD / Entra ID | "Has elegido un mecanismo de auth fuera del SSO corporativo. Justifica por qué este proyecto no puede usar Azure AD / Entra ID." |
| P02 | `Vault = "ninguno"` o secrets en repo | **Bloquear duro** | Política irrompible | "Los secrets nunca deben vivir en el repositorio. Elige un vault gestionado." |
| P03 | `Hosting = "On-premises" AND Country = Brasil` | **Bloquear blando** | LGPD residencia regional | "Hosting on-prem en Brasil requiere sign-off del DPO. Documenta la base legal." |
| P04 | `Observabilidad = "ninguna"` | **Bloquear blando** | Soporte oncall sin telemetría es inviable | "Sin observabilidad no podemos operar en producción. Justifica o elige una plataforma." |
| P05 | `ORM = EF Core AND Database = Azure SQL` | **Bloquear blando** | Dapper+SPs es el estándar recomendado | "El estándar recomendado usa Dapper+SPs por performance y auditoría. Si insistes en EF, justifica." |
| P06 | `Idioma código ≠ inglés` | **Bloquear blando** | Estándar global de código | "El estándar es código en inglés. Justifica desviación." |
| P07 | `Frontend ≠ "Ninguno" AND no se incluirá auth interceptor` | **Bloquear duro** | Tokens expuestos | "El scaffold de frontend incluye auth interceptor obligatorio. No se puede deshabilitar." |
| P08 | `Country ∈ {BR, MX, CO} AND Hosting fuera de región del país` | **Bloquear blando** | Residencia de datos | "Datos de {{Country}} deben residir en región local. Justifica la salida de jurisdicción." |
| P09 | `Soft delete = false` | **Bloquear duro** | Auditoría regulatoria | "DELETE físico no está permitido. Usa soft delete (IsActive)." |
| P10 | `CORS = "*"` | **Bloquear duro** | Riesgo XSS / CSRF | "CORS debe restringirse a dominios corporativos." |

## Mecánica de aplicación

### Bloqueo blando
1. Llamar a `AskUserQuestion` con una pregunta de texto libre.
2. Header: `Justificación`
3. Pregunta: el mensaje al desarrollador correspondiente.
4. Capturar texto.
5. Insertar en `ADR-0001` bajo "Desviaciones del estándar" con formato:
   ```
   ### Desviación P{NN}: {ConditionShort}
   **Decisión del dev:** {ElectionMade}
   **Justificación:** {DevText}
   **Riesgo aceptado:** {AutoFromTable}
   ```

### Bloqueo duro
1. NO llamar a `AskUserQuestion`.
2. Mostrar mensaje claro: "❌ No puedo generar el scaffold porque {RuleID} bloquea {Election}."
3. Ofrecer al dev volver a la pregunta correspondiente o abandonar.
4. NO escribir archivos en el repo.

## Heurísticas de "región del país" (para P08)

| País | Región Azure preferida | Región AWS preferida |
|---|---|---|
| México | Mexico Central | mx-central-1 |
| Brasil | Brazil South | sa-east-1 |
| Colombia | Brazil South / East US 2 | us-east-1 |
| Argentina | Brazil South / East US 2 | sa-east-1 |
| Chile | Chile Central (cuando disponible) / Brazil South | sa-east-1 |
| Perú | Brazil South / East US 2 | us-east-1 |
| Ecuador | Brazil South / East US 2 | us-east-1 |
| RD / PR | East US / East US 2 | us-east-1 |
