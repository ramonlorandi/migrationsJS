const { Client } = require('pg');
const fs = require('fs');
const path = require('path');

async function run() {
  const databaseUrl = process.env.DATABASE_URL;
  if (!databaseUrl) {
    console.error('ERRO: defina DATABASE_URL como variável de ambiente.');
    process.exit(1);
  }

  const migrationsDir = path.join(__dirname, '..', 'migrations');

  const migrationFiles = fs.readdirSync(migrationsDir)
    .filter(file => file.endsWith('.sql'))
    .sort();

  const client = new Client({
    connectionString: databaseUrl,
    ssl: { rejectUnauthorized: false }
  });

  try {
    await client.connect();
    console.log('Conectado ao banco.');

    for (const file of migrationFiles) {
      const filePath = path.join(migrationsDir, file);
      const sql = fs.readFileSync(filePath, 'utf8');

      console.log(`Executando migration: ${file}`);
      await client.query('BEGIN');

      const statements = sql
        .split(/;\s*$/m)
        .map(s => s.trim())
        .filter(s => s.length > 0);

      for (const stmt of statements) {
        await client.query(stmt);
      }

      await client.query('COMMIT');
      console.log(`Migration ${file} executada com sucesso.`);
    }

    console.log('Todas as migrations foram executadas com sucesso.');
  } catch (err) {
    console.error('Erro na migration:', err);
    try { await client.query('ROLLBACK'); } catch(e){}
    process.exitCode = 1;
  } finally {
    await client.end();
  }
}

run();
