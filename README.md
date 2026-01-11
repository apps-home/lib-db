# @lib/db

Submódulo compartilhado de banco de dados usando Prisma.

## 🚀 Como começar

### 1. Instalar dependências
```bash
pnpm install
```

### 2. Configurar variável de ambiente
Crie um arquivo `.env` na raiz do projeto:
```env
DATABASE_URL="postgresql://usuario:senha@localhost:5432/nome_do_banco"
```

### 3. Gerar o Prisma Client
```bash
pnpm run generate
```

### 4. (Opcional) Fazer push do schema para o banco
```bash
pnpm run db:push
```

Ou criar uma migration:
```bash
pnpm run db:migrate
```

### 5. Compilar o TypeScript
```bash
pnpm run build
```

## 📦 Scripts disponíveis

- `pnpm run generate` - Gera o Prisma Client
- `pnpm run build` - Compila o TypeScript
- `pnpm run db:push` - Faz push do schema para o banco (desenvolvimento)
- `pnpm run db:migrate` - Cria uma migration
- `pnpm run db:studio` - Abre o Prisma Studio

## 🔗 Usando em outras aplicações

Para usar este submódulo em outras aplicações, adicione no `package.json`:

```json
{
  "dependencies": {
    "@lib/db": "workspace:*"
  }
}
```

Ou via pnpm:
```bash
pnpm add @lib/db@workspace:*
```


