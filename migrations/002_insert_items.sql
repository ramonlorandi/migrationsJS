INSERT INTO desserts (country_id, name, price, description)
SELECT country_id, name, price, description FROM (
  VALUES
    (1, 'Cocada', 6.50, 'Cocada tradicional'),
    (1, 'Quindim', 7.00, 'Quindim de padaria')
) AS v(country_id, name, price, description)
WHERE NOT EXISTS (
  SELECT 1 FROM desserts d
  WHERE d.name = v.name AND d.country_id = v.country_id
);
