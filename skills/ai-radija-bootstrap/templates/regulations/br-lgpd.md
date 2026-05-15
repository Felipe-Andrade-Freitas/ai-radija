## Regulação aplicável — Brasil

**Marco:** Lei Geral de Proteção de Dados (LGPD, Lei 13.709/2018). Autoridade: ANPD (Autoridade Nacional de Proteção de Dados).

### Obrigações que o projeto deve cumprir

- **Base legal explícita** para cada tratamento (consentimento, execução de contrato, obrigação legal, proteção da vida, exercício regular de direitos, interesse legítimo, etc.).
- **DPO (Encarregado)** obrigatório — contato público.
- **RIPD (Relatório de Impacto à Proteção de Dados)** para tratamentos de alto risco.
- **Notificação de incidentes** à ANPD e ao titular em "prazo razoável" (recomendado: 72h).
- **Direitos do titular**: confirmação, acesso, correção, anonimização, portabilidade, eliminação, revogação, informação sobre compartilhamento.
- **Dados sensíveis** (origem racial, convicção religiosa, opinião política, saúde, biometria, vida sexual) requerem base legal específica.
- **Residência de dados**: preferência forte por hospedagem em região regional (Brazil South no Azure, sa-east-1 na AWS). Hospedagem fora do país requer base legal documentada + sign-off do DPO.
- **Sanções**: até 2% do faturamento (limitado a R$ 50M por infração).

### Implementação no scaffold

- Tabela `{{AppPrefix}}_LegalBases` registrando a base legal por finalidade.
- Endpoint `/api/data-rights/{portability,deletion,anonymization}`.
- Página pública `/encarregado` com contato do DPO.
- Template RIPD em `docs/ripd/template.md`.
- README e UI em **português brasileiro** (mesmo se a operação for regional).

### Dados cross-border

Permitidos para países com nível adequado declarado pela ANPD, ou sob cláusulas contratuais/normas corporativas/consentimento específico. EUA não tem decisão de adequação — usar SCCs.
