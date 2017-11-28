-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema licitatoriumdb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema licitatoriumdb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `licitatoriumdb` DEFAULT CHARACTER SET utf8 ;
USE `licitatoriumdb` ;

-- -----------------------------------------------------
-- Table `licitatoriumdb`.`ModalidadeLicitacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `licitatoriumdb`.`ModalidadeLicitacao` (
  `codigo` INT NOT NULL,
  `descricao` VARCHAR(45) NULL,
  PRIMARY KEY (`codigo`),
  UNIQUE INDEX `descricao_UNIQUE` (`descricao` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `licitatoriumdb`.`Orgao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `licitatoriumdb`.`Orgao` (
  `codigo` INT NOT NULL,
  `nome` VARCHAR(100) NULL,
  `ativo` TINYINT(1) NULL,
  `codigo_tipo_esfera` VARCHAR(45) NULL,
  `codigo_tipo_adm` INT NULL,
  `codigo_tipo_poder` INT NULL,
  `codigo_siorg` VARCHAR(45) NULL,
  PRIMARY KEY (`codigo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `licitatoriumdb`.`UASG`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `licitatoriumdb`.`UASG` (
  `ativo` TINYINT(1) NULL,
  `cep` VARCHAR(45) NULL,
  `ddd` VARCHAR(45) NULL,
  `endereco` VARCHAR(150) NULL,
  `fax` VARCHAR(45) NULL,
  `id` INT NOT NULL,
  `id_municipio` INT NULL,
  `id_orgao` INT NULL,
  `nome` VARCHAR(255) NULL,
  `nome_mnemonico` VARCHAR(45) NULL,
  `ramal` VARCHAR(45) NULL,
  `ramal2` VARCHAR(45) NULL,
  `sigla_uf` VARCHAR(45) NULL,
  `telefone` VARCHAR(45) NULL,
  `telefone2` VARCHAR(45) NULL,
  `total_fornecedores_cadastrados` VARCHAR(45) NULL,
  `total_fornecedores_recadastrados` VARCHAR(45) NULL,
  `unidade_cadastradora` VARCHAR(45) NULL,
  INDEX `fk_UASG_1_idx` (`id_orgao` ASC),
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_UASG_1`
    FOREIGN KEY (`id_orgao`)
    REFERENCES `licitatoriumdb`.`Orgao` (`codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `licitatoriumdb`.`Licitacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `licitatoriumdb`.`Licitacao` (
  `identificador` VARCHAR(100) NOT NULL,
  `data_abertura_proposta` DATETIME NULL,
  `data_entrega_edital` DATETIME NULL,
  `data_entrega_proposta` DATETIME NULL,
  `data_publicacao` DATETIME NULL,
  `endereco_entrega_edital` VARCHAR(45) NULL,
  `funcao_responsavel` VARCHAR(45) NULL,
  `informacoes_gerais` VARCHAR(45) NULL,
  `modalidade` INT NULL,
  `nome_responsavel` VARCHAR(45) NULL,
  `numero_aviso` INT NULL,
  `numero_itens` INT NULL,
  `numero_processo` VARCHAR(45) NULL,
  `objeto` VARCHAR(45) NULL,
  `situacao_aviso` VARCHAR(45) NULL,
  `tipo_pregao` VARCHAR(45) NULL,
  `tipo_recurso` VARCHAR(45) NULL,
  `uasg` INT NULL,
  PRIMARY KEY (`identificador`),
  INDEX `fk_Licitacao_1_idx` (`modalidade` ASC),
  INDEX `fk_Licitacao_2_idx` (`uasg` ASC),
  CONSTRAINT `fk_Licitacao_1`
    FOREIGN KEY (`modalidade`)
    REFERENCES `licitatoriumdb`.`ModalidadeLicitacao` (`codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Licitacao_2`
    FOREIGN KEY (`uasg`)
    REFERENCES `licitatoriumdb`.`UASG` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `licitatoriumdb`.`RegistroPreco`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `licitatoriumdb`.`RegistroPreco` (
  `id_licitacao` VARCHAR(100) NOT NULL,
  `data_inicio_validade` DATETIME NULL,
  `data_fim_validade` DATETIME NULL,
  `data_assinatura` DATETIME NULL,
  `valor_total` DECIMAL NULL,
  `valor_renegociado` DECIMAL NULL,
  INDEX `fk_RegistroPreco_1_idx` (`id_licitacao` ASC),
  PRIMARY KEY (`id_licitacao`),
  UNIQUE INDEX `id_licitacao_UNIQUE` (`id_licitacao` ASC),
  CONSTRAINT `fk_RegistroPreco_1`
    FOREIGN KEY (`id_licitacao`)
    REFERENCES `licitatoriumdb`.`Licitacao` (`identificador`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `licitatoriumdb`.`ItemRegistroPreco`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `licitatoriumdb`.`ItemRegistroPreco` (
  `numero_registro_preco` VARCHAR(100) NOT NULL,
  `numero_item_licitacao` INT NOT NULL,
  `marca` VARCHAR(45) NULL,
  `classificacaoFornecedor` VARCHAR(45) NULL,
  `quantidade_empenhada` INT(11) NULL,
  `quantidade_total` INT(11) NULL,
  `quantidade_a_empenhar` INT(11) NULL,
  `beneficio` VARCHAR(255) NULL,
  PRIMARY KEY (`numero_registro_preco`, `numero_item_licitacao`),
  CONSTRAINT `fk_ItemRegistroPreco_1`
    FOREIGN KEY (`numero_registro_preco`)
    REFERENCES `licitatoriumdb`.`RegistroPreco` (`id_licitacao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `licitatoriumdb`.`PrecoPraticado`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `licitatoriumdb`.`PrecoPraticado` (
  `id_licitacao` VARCHAR(45) NOT NULL,
  `valor_total` VARCHAR(45) NULL,
  PRIMARY KEY (`id_licitacao`),
  CONSTRAINT `fk_PrecoPraticado_1`
    FOREIGN KEY (`id_licitacao`)
    REFERENCES `licitatoriumdb`.`Licitacao` (`identificador`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `licitatoriumdb`.`ItemPrecoPraticado`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `licitatoriumdb`.`ItemPrecoPraticado` (
  `unidade` VARCHAR(20) NOT NULL,
  `valor_total` DECIMAL NULL,
  `valor_unitario` DECIMAL NULL,
  `quantidade` INT NULL,
  `numero_item_licitacao` INT NULL,
  `marca` VARCHAR(45) NULL,
  `codigo_item_material` INT NULL,
  `codigo_item_servico` INT NULL,
  `cnpj_fornecedor` VARCHAR(45) NULL,
  `id_licitacao` VARCHAR(100) NULL,
  PRIMARY KEY (`unidade`),
  INDEX `fk_ItemPrecoPraticado_1_idx` (`id_licitacao` ASC),
  CONSTRAINT `fk_ItemPrecoPraticado_1`
    FOREIGN KEY (`id_licitacao`)
    REFERENCES `licitatoriumdb`.`PrecoPraticado` (`id_licitacao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `licitatoriumdb`.`FornecedorRegistroPreco`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `licitatoriumdb`.`FornecedorRegistroPreco` (
  `cnpj_fornecedor` INT NOT NULL,
  `nome_fornecedor` VARCHAR(45) NULL,
  `classificacao_fornecedor` VARCHAR(45) NULL,
  `id_registro_preco` VARCHAR(100) NOT NULL,
  `numero_item_licitacao` INT NOT NULL,
  PRIMARY KEY (`cnpj_fornecedor`, `id_registro_preco`, `numero_item_licitacao`),
  INDEX `fk_FornecedorRegistroPreco_1_idx` (`id_registro_preco` ASC, `numero_item_licitacao` ASC),
  CONSTRAINT `fk_FornecedorRegistroPreco_1`
    FOREIGN KEY (`id_registro_preco` , `numero_item_licitacao`)
    REFERENCES `licitatoriumdb`.`ItemRegistroPreco` (`numero_registro_preco` , `numero_item_licitacao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `licitatoriumdb`.`RenegFornItemRegistroPreco`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `licitatoriumdb`.`RenegFornItemRegistroPreco` (
  `cnpj_fornecedor` INT NOT NULL,
  `id_registro_preco` VARCHAR(100) NOT NULL,
  `valor_renegociado` DECIMAL NULL,
  `data_renegociacao` DATETIME NULL,
  `numero_renegociacao` INT NOT NULL,
  `numero_item_licitacao` INT NOT NULL,
  PRIMARY KEY (`numero_renegociacao`),
  INDEX `fk_RenegFornItemRegistroPreco_1_idx` (`cnpj_fornecedor` ASC, `id_registro_preco` ASC, `numero_item_licitacao` ASC),
  CONSTRAINT `fk_RenegFornItemRegistroPreco_1`
    FOREIGN KEY (`cnpj_fornecedor` , `id_registro_preco` , `numero_item_licitacao`)
    REFERENCES `licitatoriumdb`.`FornecedorRegistroPreco` (`cnpj_fornecedor` , `id_registro_preco` , `numero_item_licitacao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `licitatoriumdb`.`ClasseMaterial`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `licitatoriumdb`.`ClasseMaterial` (
  `codigo` INT NOT NULL,
  `descricao` VARCHAR(45) NULL,
  `codigo_grupo` VARCHAR(45) NULL,
  PRIMARY KEY (`codigo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `licitatoriumdb`.`GrupoMaterial`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `licitatoriumdb`.`GrupoMaterial` (
  `codigo` INT NOT NULL,
  `descricao` VARCHAR(100) NULL,
  PRIMARY KEY (`codigo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `licitatoriumdb`.`Material`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `licitatoriumdb`.`Material` (
  `codigo` INT NOT NULL,
  `descricao` VARCHAR(150) NULL,
  `id_grupo` INT NULL,
  `id_classe` INT NULL,
  `id_pdm` VARCHAR(45) NULL,
  `status` TINYINT(1) NULL,
  `sustentavel` TINYINT(1) NULL,
  PRIMARY KEY (`codigo`),
  INDEX `fk_Material_1_idx` (`id_classe` ASC),
  INDEX `fk_Material_2_idx` (`id_grupo` ASC),
  CONSTRAINT `fk_Material_1`
    FOREIGN KEY (`id_classe`)
    REFERENCES `licitatoriumdb`.`ClasseMaterial` (`codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Material_2`
    FOREIGN KEY (`id_grupo`)
    REFERENCES `licitatoriumdb`.`GrupoMaterial` (`codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `licitatoriumdb`.`SecaoServico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `licitatoriumdb`.`SecaoServico` (
  `codigo` INT NOT NULL,
  `descricao` VARCHAR(45) NULL,
  PRIMARY KEY (`codigo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `licitatoriumdb`.`DivisaoServico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `licitatoriumdb`.`DivisaoServico` (
  `codigo` INT NOT NULL,
  `descricao` VARCHAR(45) NULL,
  `codigo_secao` VARCHAR(45) NULL,
  PRIMARY KEY (`codigo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `licitatoriumdb`.`GrupoServico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `licitatoriumdb`.`GrupoServico` (
  `codigo` INT NOT NULL,
  `descricao` VARCHAR(45) NULL,
  `codigo_divisao` INT NULL,
  PRIMARY KEY (`codigo`),
  INDEX `fk_GrupoServico_1_idx` (`codigo_divisao` ASC),
  CONSTRAINT `fk_GrupoServico_1`
    FOREIGN KEY (`codigo_divisao`)
    REFERENCES `licitatoriumdb`.`DivisaoServico` (`codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `licitatoriumdb`.`ClasseServico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `licitatoriumdb`.`ClasseServico` (
  `codigo` INT NOT NULL,
  `descricao` VARCHAR(45) NULL,
  `codigo_grupo` INT NULL,
  PRIMARY KEY (`codigo`),
  INDEX `fk_ClasseServico_1_idx` (`codigo_grupo` ASC),
  CONSTRAINT `fk_ClasseServico_1`
    FOREIGN KEY (`codigo_grupo`)
    REFERENCES `licitatoriumdb`.`GrupoServico` (`codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `licitatoriumdb`.`Servico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `licitatoriumdb`.`Servico` (
  `codigo` INT NOT NULL,
  `descricao` VARCHAR(45) NULL,
  `unidade_medida` VARCHAR(45) NULL,
  `cpc` INT NULL,
  `codigo_secao` INT NULL,
  `codigo_divisao` INT NULL,
  `codigo_grupo` INT NULL,
  `codigo_classe` INT NULL,
  PRIMARY KEY (`codigo`),
  INDEX `fk_Servico_1_idx` (`codigo_secao` ASC),
  INDEX `fk_Servico_2_idx` (`codigo_divisao` ASC),
  INDEX `fk_Servico_3_idx` (`codigo_grupo` ASC),
  INDEX `fk_Servico_4_idx` (`codigo_classe` ASC),
  CONSTRAINT `fk_Servico_1`
    FOREIGN KEY (`codigo_secao`)
    REFERENCES `licitatoriumdb`.`SecaoServico` (`codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Servico_2`
    FOREIGN KEY (`codigo_divisao`)
    REFERENCES `licitatoriumdb`.`DivisaoServico` (`codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Servico_3`
    FOREIGN KEY (`codigo_grupo`)
    REFERENCES `licitatoriumdb`.`GrupoServico` (`codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Servico_4`
    FOREIGN KEY (`codigo_classe`)
    REFERENCES `licitatoriumdb`.`ClasseServico` (`codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `licitatoriumdb`.`ItemLicitacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `licitatoriumdb`.`ItemLicitacao` (
  `cnpj_fornecedor` INT NOT NULL,
  `codigo_item_material` INT NULL,
  `codigo_item_servico` INT NULL,
  `cpfVencedor` VARCHAR(45) NULL,
  `criterio_julgamento` VARCHAR(45) NULL,
  `decreto_7174` VARCHAR(45) NULL,
  `descricao_item` VARCHAR(45) NULL,
  `numero_item_licitacao` VARCHAR(45) NULL,
  `numero_licitacao` VARCHAR(100) NULL,
  `quantidade` VARCHAR(45) NULL,
  `sustentavel` VARCHAR(45) NULL,
  `unidade` VARCHAR(45) NULL,
  `valor_estimado` DECIMAL NULL,
  PRIMARY KEY (`cnpj_fornecedor`),
  INDEX `fk_ItemLicitacao_1_idx` (`numero_licitacao` ASC),
  INDEX `fk_ItemLicitacao_2_idx` (`codigo_item_material` ASC),
  INDEX `fk_ItemLicitacao_3_idx` (`codigo_item_servico` ASC),
  CONSTRAINT `fk_ItemLicitacao_1`
    FOREIGN KEY (`numero_licitacao`)
    REFERENCES `licitatoriumdb`.`Licitacao` (`identificador`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ItemLicitacao_2`
    FOREIGN KEY (`codigo_item_material`)
    REFERENCES `licitatoriumdb`.`Material` (`codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ItemLicitacao_3`
    FOREIGN KEY (`codigo_item_servico`)
    REFERENCES `licitatoriumdb`.`Servico` (`codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `licitatoriumdb`.`TipoContrato`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `licitatoriumdb`.`TipoContrato` (
  `codigo` INT NOT NULL,
  `descricao` VARCHAR(45) NULL,
  PRIMARY KEY (`codigo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `licitatoriumdb`.`Contrato`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `licitatoriumdb`.`Contrato` (
  `cnpj_contratada` INT NULL,
  `codigo_contrato` INT NULL,
  `cpfContratada` VARCHAR(45) NULL,
  `data_assinatura` DATETIME NULL,
  `data_inicio_vigencia` DATETIME NULL,
  `data_termino_vigencia` DATETIME NULL,
  `fundamento_legal` VARCHAR(45) NULL,
  `identificador` VARCHAR(45) NOT NULL,
  `licitacao_associada` VARCHAR(100) NULL,
  `modalidade_licitacao` VARCHAR(45) NULL,
  `numero` INT NULL,
  `numero_aditivo` VARCHAR(45) NULL,
  `numero_processo` VARCHAR(45) NULL,
  `objeto` VARCHAR(45) NULL,
  `valor_inicial` DECIMAL NULL,
  PRIMARY KEY (`identificador`),
  INDEX `fk_Contrato_1_idx` (`licitacao_associada` ASC),
  INDEX `fk_Contrato_2_idx` (`codigo_contrato` ASC),
  CONSTRAINT `fk_Contrato_1`
    FOREIGN KEY (`licitacao_associada`)
    REFERENCES `licitatoriumdb`.`Licitacao` (`identificador`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Contrato_2`
    FOREIGN KEY (`codigo_contrato`)
    REFERENCES `licitatoriumdb`.`TipoContrato` (`codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `licitatoriumdb`.`EventoContrato`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `licitatoriumdb`.`EventoContrato` (
  `codigo_evento` INT NOT NULL,
  `dataPublicacao` VARCHAR(45) NULL,
  `dataRescisao` VARCHAR(45) NULL,
  `data_assinatura_anterior` VARCHAR(45) NULL,
  `data_inicio_vigencia_anterior` VARCHAR(45) NULL,
  `fundamento_legal` VARCHAR(45) NULL,
  `id_contrato` VARCHAR(45) NOT NULL,
  `justificativa_evento` VARCHAR(45) NULL,
  `justificativa_valor` VARCHAR(45) NULL,
  `leia_se` VARCHAR(45) NULL,
  `nome_evento` VARCHAR(45) NULL,
  `numeroAditivo` VARCHAR(45) NULL,
  `numeroEvento` VARCHAR(45) NULL,
  `onde_se_le` VARCHAR(45) NULL,
  `status` VARCHAR(45) NULL,
  `valor_parcela_anterior` VARCHAR(45) NULL,
  `valor_total_anterior` VARCHAR(45) NULL,
  PRIMARY KEY (`codigo_evento`, `id_contrato`),
  INDEX `fk_EventoContrato_1_idx` (`id_contrato` ASC),
  CONSTRAINT `fk_EventoContrato_1`
    FOREIGN KEY (`id_contrato`)
    REFERENCES `licitatoriumdb`.`Contrato` (`identificador`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `licitatoriumdb`.`Municipio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `licitatoriumdb`.`Municipio` (
  `ativo` TINYINT(1) NULL,
  `id` INT NOT NULL,
  `nome` VARCHAR(45) NULL,
  `nome_uf` VARCHAR(45) NULL,
  `sigla_uf` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `licitatoriumdb`.`NaturezaJuridica`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `licitatoriumdb`.`NaturezaJuridica` (
  `id` INT NOT NULL,
  `descricao` VARCHAR(45) NULL,
  `ativo` TINYINT(1) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `licitatoriumdb`.`PorteEmpresa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `licitatoriumdb`.`PorteEmpresa` (
  `id` INT NOT NULL,
  `descricao` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `licitatoriumdb`.`RamoNegocio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `licitatoriumdb`.`RamoNegocio` (
  `id` INT NOT NULL,
  `descricao` VARCHAR(100) NULL,
  `ativo` TINYINT(1) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `licitatoriumdb`.`Fornecedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `licitatoriumdb`.`Fornecedor` (
  `cnpj` VARCHAR(45) NOT NULL,
  `ativo` TINYINT(1) NULL,
  `cpf` VARCHAR(45) NULL,
  `habilitado_licitar` TINYINT(1) NULL,
  `id` VARCHAR(45) NULL,
  `id_cnae` VARCHAR(45) NULL,
  `id_cnae2` VARCHAR(45) NULL,
  `id_municipio` INT NULL,
  `id_natureza_juridica` INT NULL,
  `id_porte_empresa` INT NULL,
  `id_ramo_negocio` INT NULL,
  `id_unidade_cadastradora` INT NULL,
  `nome` VARCHAR(45) NULL,
  `recadastrado` TINYINT(1) NULL,
  `uf` VARCHAR(45) NULL,
  PRIMARY KEY (`cnpj`),
  INDEX `fk_Fornecedor_1_idx` (`id_municipio` ASC),
  INDEX `fk_Fornecedor_2_idx` (`id_natureza_juridica` ASC),
  INDEX `fk_Fornecedor_3_idx` (`id_porte_empresa` ASC),
  INDEX `fk_Fornecedor_4_idx` (`id_ramo_negocio` ASC),
  INDEX `fk_Fornecedor_5_idx` (`id_unidade_cadastradora` ASC),
  CONSTRAINT `fk_Fornecedor_1`
    FOREIGN KEY (`id_municipio`)
    REFERENCES `licitatoriumdb`.`Municipio` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Fornecedor_2`
    FOREIGN KEY (`id_natureza_juridica`)
    REFERENCES `licitatoriumdb`.`NaturezaJuridica` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Fornecedor_3`
    FOREIGN KEY (`id_porte_empresa`)
    REFERENCES `licitatoriumdb`.`PorteEmpresa` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Fornecedor_4`
    FOREIGN KEY (`id_ramo_negocio`)
    REFERENCES `licitatoriumdb`.`RamoNegocio` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Fornecedor_5`
    FOREIGN KEY (`id_unidade_cadastradora`)
    REFERENCES `licitatoriumdb`.`UASG` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `licitatoriumdb`.`TiposOcorrencia`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `licitatoriumdb`.`TiposOcorrencia` (
  `id` INT NOT NULL,
  `descricao` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `licitatoriumdb`.`OcorrenciaFornecedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `licitatoriumdb`.`OcorrenciaFornecedor` (
  `id` INT NOT NULL,
  `cnpj` VARCHAR(45) NULL,
  `tipo_pessoa` VARCHAR(45) NULL,
  `numero_processo` VARCHAR(45) NULL,
  `id_unidade_cadastradora` INT NULL,
  `id_tipo_ocorrencia` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_OcorrenciaFornecedor_1_idx` (`cnpj` ASC),
  INDEX `fk_OcorrenciaFornecedor_2_idx` (`id_tipo_ocorrencia` ASC),
  CONSTRAINT `fk_OcorrenciaFornecedor_1`
    FOREIGN KEY (`cnpj`)
    REFERENCES `licitatoriumdb`.`Fornecedor` (`cnpj`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_OcorrenciaFornecedor_2`
    FOREIGN KEY (`id_tipo_ocorrencia`)
    REFERENCES `licitatoriumdb`.`TiposOcorrencia` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
