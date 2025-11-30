const { Client } = require('pg');
const fs = require('fs');
const path = require('path');

async function run() {
  const databaseUrl = process.env.DATABASE_URL;
  if (!databaseUrl) {
    console.error('ERRO: defina DATABASE_URL como variável de ambiente (ex: postgres://user:pass@host:5432/dbname)');
    process.exit(1);
  }

  const sqlPath = path.join(__dirname, '..', 'migrations', '001_create_tables.sql');
  const sql = fs.readFileSync(sqlPath, 'utf8');

  const client = new Client({ connectionString: databaseUrl, ssl: { rejectUnauthorized: false } });
  try {
    await client.connect();
    console.log('Conectado ao banco. Executando migration...');
    await client.query('BEGIN');
    await client.query(sql);
    await client.query('COMMIT');
    console.log('Migration executada com sucesso.');
  } catch (err) {
    console.error('Erro na migration:', err);
    try { await client.query('ROLLBACK'); } catch(e){/* ignore */ }
    process.exitCode = 1;
  } finally {
    await client.end();
  }
}

run();
