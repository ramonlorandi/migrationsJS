CREATE TABLE IF NOT EXISTS countries (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  region VARCHAR(100),
  iso_code CHAR(3),
  notes TEXT
);

INSERT INTO countries (name, region, iso_code, notes) VALUES
('Brasil','América do Sul','BRA','País com várias sobremesas por região'),
('França','Europa','FRA','Alta tradição patisserie'),
('Itália','Europa','ITA','Conhecida por gelato e tiramisu'),
('Japão','Ásia','JPN','Doces tradicionais como wagashi'),
('Estados Unidos','América do Norte','USA','Sobremesas variadas'),
('México','América do Norte','MEX','Doces com sabores intensos'),
('Portugal','Europa','PRT','Doces conventuais'),
('Canadá','América do Norte','CAN','Doces industrializados')
ON CONFLICT (name) DO NOTHING;

CREATE TABLE IF NOT EXISTS desserts (
  id SERIAL PRIMARY KEY,
  country_id INTEGER REFERENCES countries(id),
  name VARCHAR(150) NOT NULL,
  price NUMERIC(8,2) DEFAULT 0.00,
  description TEXT
);

INSERT INTO desserts (country_id, name, price, description)
SELECT country_id, name, price, description FROM (
  VALUES
    (1,'Brigadeiro',5.00,'Docinho brasileiro tradicional'),
    (1,'Pudim',8.50,'Pudim de leite condensado'),
    (2,'Crème brûlée',14.00,'Creme com crosta de açúcar queimado'),
    (3,'Tiramisu',18.00,'Sobremesa italiana com café'),
    (4,'Mochi',6.50,'Bolinhas de arroz glutinoso'),
    (5,'Brownie',7.00,'Brownie de chocolate'),
    (6,'Churros',9.00,'Churros recheados'),
    (8,'Pirulito',4.00,'Pirulito gigante')
) AS v(country_id, name, price, description)
WHERE NOT EXISTS (
  SELECT 1 FROM desserts d WHERE d.name = v.name AND d.country_id = v.country_id
);

CREATE TABLE IF NOT EXISTS suppliers (
  id SERIAL PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  contact_email VARCHAR(150),
  phone VARCHAR(50),
  address TEXT
);

INSERT INTO suppliers (name, contact_email, phone, address)
SELECT name, contact_email, phone, address FROM (
  VALUES
    ('Fornecedor A','contato@forna.com','+55 11 99999-0001','Rua A, 123'),
    ('Fornecedor B','contato@fornb.com','+55 11 99999-0002','Rua B, 456'),
    ('Fornecedor C','contato@fornc.com','+55 11 99999-0003','Rua C, 789'),
    ('Fornecedor D','contato@fornd.com','+55 11 99999-0004','Rua D, 101'),
    ('Fornecedor E','contato@forne.com','+55 11 99999-0005','Rua E, 102'),
    ('Fornecedor F','contato@fornf.com','+55 11 99999-0006','Rua F, 103'),
    ('Fornecedor G','contato@forng.com','+55 11 99999-0007','Rua G, 104')
) AS v(name, contact_email, phone, address)
WHERE NOT EXISTS (
  SELECT 1 FROM suppliers s WHERE s.name = v.name AND s.contact_email = v.contact_email
);
