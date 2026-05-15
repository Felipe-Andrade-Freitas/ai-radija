## Regulación aplicable — Colombia

**Marco:** Ley Estatutaria 1581 de 2012 + Decreto 1377 de 2013. Autoridad: Superintendencia de Industria y Comercio (SIC).

### Obligaciones que el proyecto debe cumplir

- **Registro Nacional de Bases de Datos (RNBD)** ante la SIC para toda BD que contenga datos personales.
- **Autorización previa, expresa e informada** del titular antes de tratar sus datos.
- **Política de tratamiento** publicada y accesible.
- **Derechos del titular**: conocer, actualizar, rectificar, solicitar prueba de autorización, ser informado del uso, presentar quejas, revocar autorización, acceder gratuitamente.
- **Datos sensibles** (salud, biométricos, orientación sexual, ideología) requieren consentimiento expreso adicional.
- **Notificación de incidentes** a la SIC en máximo 15 días hábiles.
- **Datos de menores** sólo pueden tratarse en función del interés superior del niño.

### Implementación en el scaffold

- Tabla `{{AppPrefix}}_Authorizations` con `UserId`, `Purpose`, `AuthorizedAt`, `RevokedAt`, `EvidenceUrl`.
- Endpoint `/api/data-rights/{action}` para los 8 derechos del titular.
- Job programado para inactivar (soft delete) registros vencidos por política de retención.
- Documento `database/rnbd-registration.md` con los metadatos para registrar la BD ante la SIC.

### Datos cross-border

Transferencias a países sin nivel adecuado requieren autorización del titular o cláusulas contractuales tipo. Documentar la base legal en el aviso.
