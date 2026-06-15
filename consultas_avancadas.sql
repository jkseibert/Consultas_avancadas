use restaurante;

SELECT * FROM produtos LIMIT 10;
SELECT * FROM info_produtos LIMIT 10;
SELECT * FROM pedidos LIMIT 100;
SELECT * FROM clientes LIMIT 10;
SELECT * FROM funcionarios LIMIT 10;

SELECT * FROM resumo_pedido;

CREATE VIEW resumo_pedido AS
SELECT 
  c.nome, 
  c.email, 
  pe.id_pedido, 
  pe.data_pedido, 
  SUM(p.preco * pe.quantidade) AS info_pedidos, 
  f.nome AS funcionario, 
  p.nome AS produto
FROM 
  clientes c
  JOIN pedidos pe ON c.id_cliente = pe.id_cliente
  JOIN produtos p ON pe.id_produto = p.id_produto
  JOIN funcionarios f ON pe.id_funcionario = f.id_funcionario
GROUP BY 
  c.nome, 
  c.email, 
  pe.id_pedido, 
  pe.data_pedido, 
  f.nome, 
  p.nome;
  
  SELECT id_pedido, nome, info_pedidos FROM resumo_pedido;
  
 ALTER VIEW resumo_pedido AS
SELECT
    c.nome,
    c.email,
    pe.id_pedido,
    pe.data_pedido,
    SUM(p.preco * pe.quantidade) AS info_pedidos,
    f.nome AS funcionario,
    p.nome AS produto,
    count(pe.quantidade) AS total   
FROM
    clientes c
    JOIN pedidos pe ON c.id_cliente = pe.id_cliente
    JOIN produtos p ON pe.id_produto = p.id_produto
    JOIN funcionarios f ON pe.id_funcionario = f.id_funcionario
GROUP BY
    c.nome,
    c.email,
    pe.id_pedido,
    pe.data_pedido,
    f.nome,
    p.nome;
    
 SELECT id_pedido, nome, info_pedidos, total FROM resumo_pedido;
 
 DELIMITER //
CREATE FUNCTION BuscaIngredientesProduto(IdProduto INT)
RETURNS VARCHAR(200)
READS SQL DATA
BEGIN
	DECLARE lista_ingredientes VARCHAR(200);
    SELECT ingredientes INTO lista_ingredientes FROM info_produtos WHERE id_produto = IdProduto;
    RETURN lista_ingredientes;
END //
DELIMITER ;

SELECT BuscaIngredientesProduto(10);

DELIMITER //
CREATE FUNCTION MediaPedido(produtoID INT)
RETURNS VARCHAR(100)
READS SQL DATA
BEGIN
	DECLARE totalPedidos DECIMAL(10, 2);
    DECLARE desempenho VARCHAR(100);
    
    SELECT COALESCE(sum(p.preco * pe.quantidade), 0) INTO totalPedidos
    FROM produtos p 
    LEFT JOIN pedidos pe ON p.id_produto = pe.id_produto
    WHERE p.id_produto = produtoID;
    
    SET desempenho =
    CASE
		WHEN totalPedidos = 0 THEN 'Sem Pedidos'
        WHEN totalPedidos <= 1 THEN 'Baixo'
        WHEN totalPedidos <= 3 THEN 'Médio'
        ELSE 'Alto'
	END;
    
    RETURN desempenho;
END //
DELIMITER ;

SELECT MediaPedido(5);
  
SELECT MediaPedido(6);

  
  
    