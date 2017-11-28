-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`ModalidadeLicitacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`ModalidadeLicitacao` (
  `codigo` INT NOT NULL,
  `descricao` VARCHAR(45) NULL,
  PRIMARY KEY (`codigo`),
  UNIQUE INDEX `descricao_UNIQUE` (`descricao` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Orgao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Orgao` (
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
-- Table `mydb`.`UASG`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`UASG` (
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
    REFERENCES `mydb`.`Orgao` (`codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Licitacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Licitacao` (
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
    REFERENCES `mydb`.`ModalidadeLicitacao` (`codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Licitacao_2`
    FOREIGN KEY (`uasg`)
    REFERENCES `mydb`.`UASG` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`RegistroPreco`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`RegistroPreco` (
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
    REFERENCES `mydb`.`Licitacao` (`identificador`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`ItemRegistroPreco`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`ItemRegistroPreco` (
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
    REFERENCES `mydb`.`RegistroPreco` (`id_licitacao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`PrecoPraticado`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`PrecoPraticado` (
  `id_licitacao` VARCHAR(45) NOT NULL,
  `valor_total` VARCHAR(45) NULL,
  PRIMARY KEY (`id_licitacao`),
  CONSTRAINT `fk_PrecoPraticado_1`
    FOREIGN KEY (`id_licitacao`)
    REFERENCES `mydb`.`Licitacao` (`identificador`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`ItemPrecoPraticado`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`ItemPrecoPraticado` (
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
    REFERENCES `mydb`.`PrecoPraticado` (`id_licitacao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`FornecedorRegistroPreco`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`FornecedorRegistroPreco` (
  `cnpj_fornecedor` INT NOT NULL,
  `nome_fornecedor` VARCHAR(45) NULL,
  `classificacao_fornecedor` VARCHAR(45) NULL,
  `id_registro_preco` VARCHAR(100) NOT NULL,
  `numero_item_licitacao` INT NOT NULL,
  PRIMARY KEY (`cnpj_fornecedor`, `numero_item_licitacao`, `id_registro_preco`),
  INDEX `fk_FornecedorRegistroPreco_1_idx` (`numero_item_licitacao` ASC, `id_registro_preco` ASC),
  CONSTRAINT `fk_FornecedorRegistroPreco_1`
    FOREIGN KEY (`numero_item_licitacao` , `id_registro_preco`)
    REFERENCES `mydb`.`ItemRegistroPreco` (`numero_item_licitacao` , `numero_registro_preco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`RenegociacaoFornecedorItemRegistroPreco`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`RenegociacaoFornecedorItemRegistroPreco` (
  `cnpj_fornecedor` INT NOT NULL,
  `id_registro_preco` VARCHAR(45) NOT NULL,
  `numero_item_licitacao` INT NOT NULL,
  `valor_renegociado` DECIMAL NULL,
  `data_renegociacao` DATETIME NULL,
  `numero_renegociacao` INT NOT NULL,
  PRIMARY KEY (`cnpj_fornecedor`, `id_registro_preco`, `numero_item_licitacao`, `numero_renegociacao`),
  INDEX `fk_RenegociacaoFornecedorItemRegistroPreco_1_idx` (`cnpj_fornecedor` ASC, `id_registro_preco` ASC, `numero_item_licitacao` ASC),
  CONSTRAINT `fk_RenegociacaoFornecedorItemRegistroPreco_1`
    FOREIGN KEY (`cnpj_fornecedor` , `id_registro_preco` , `numero_item_licitacao`)
    REFERENCES `mydb`.`FornecedorRegistroPreco` (`cnpj_fornecedor` , `id_registro_preco` , `numero_item_licitacao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`ClasseMaterial`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`ClasseMaterial` (
  `codigo` INT NOT NULL,
  `descricao` VARCHAR(45) NULL,
  `codigo_grupo` VARCHAR(45) NULL,
  PRIMARY KEY (`codigo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`GrupoMaterial`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`GrupoMaterial` (
  `codigo` INT NOT NULL,
  `descricao` VARCHAR(100) NULL,
  PRIMARY KEY (`codigo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Material`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Material` (
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
    REFERENCES `mydb`.`ClasseMaterial` (`codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Material_2`
    FOREIGN KEY (`id_grupo`)
    REFERENCES `mydb`.`GrupoMaterial` (`codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`SecaoServico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`SecaoServico` (
  `codigo` INT NOT NULL,
  `descricao` VARCHAR(45) NULL,
  PRIMARY KEY (`codigo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`DivisaoServico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`DivisaoServico` (
  `codigo` INT NOT NULL,
  `descricao` VARCHAR(45) NULL,
  `codigo_secao` VARCHAR(45) NULL,
  PRIMARY KEY (`codigo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`GrupoServico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`GrupoServico` (
  `codigo` INT NOT NULL,
  `descricao` VARCHAR(45) NULL,
  `codigo_divisao` INT NULL,
  PRIMARY KEY (`codigo`),
  CONSTRAINT `fk_GrupoServico_1`
    FOREIGN KEY ()
    REFERENCES `mydb`.`DivisaoServico` ()
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`ClasseServico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`ClasseServico` (
  `codigo` INT NOT NULL,
  `descricao` VARCHAR(45) NULL,
  `codigo_grupo` INT NULL,
  PRIMARY KEY (`codigo`),
  INDEX `fk_ClasseServico_1_idx` (`codigo_grupo` ASC),
  CONSTRAINT `fk_ClasseServico_1`
    FOREIGN KEY (`codigo_grupo`)
    REFERENCES `mydb`.`GrupoServico` (`codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Servico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Servico` (
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
    REFERENCES `mydb`.`SecaoServico` (`codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Servico_2`
    FOREIGN KEY (`codigo_divisao`)
    REFERENCES `mydb`.`DivisaoServico` (`codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Servico_3`
    FOREIGN KEY (`codigo_grupo`)
    REFERENCES `mydb`.`GrupoServico` (`codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Servico_4`
    FOREIGN KEY (`codigo_classe`)
    REFERENCES `mydb`.`ClasseServico` (`codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`ItemLicitacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`ItemLicitacao` (
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
    REFERENCES `mydb`.`Licitacao` (`identificador`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ItemLicitacao_2`
    FOREIGN KEY (`codigo_item_material`)
    REFERENCES `mydb`.`Material` (`codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ItemLicitacao_3`
    FOREIGN KEY (`codigo_item_servico`)
    REFERENCES `mydb`.`Servico` (`codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`TipoContrato`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`TipoContrato` (
  `codigo` INT NOT NULL,
  `descricao` VARCHAR(45) NULL,
  PRIMARY KEY (`codigo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Contrato`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Contrato` (
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
    REFERENCES `mydb`.`Licitacao` (`identificador`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Contrato_2`
    FOREIGN KEY (`codigo_contrato`)
    REFERENCES `mydb`.`TipoContrato` (`codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`EventoContrato`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`EventoContrato` (
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
    REFERENCES `mydb`.`Contrato` (`identificador`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Municipio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Municipio` (
  `ativo` TINYINT(1) NULL,
  `id` INT NOT NULL,
  `nome` VARCHAR(45) NULL,
  `nome_uf` VARCHAR(45) NULL,
  `sigla_uf` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`NaturezaJuridica`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`NaturezaJuridica` (
  `id` INT NOT NULL,
  `descricao` VARCHAR(45) NULL,
  `ativo` TINYINT(1) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`PorteEmpresa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`PorteEmpresa` (
  `id` INT NOT NULL,
  `descricao` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`RamoNegocio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`RamoNegocio` (
  `id` INT NOT NULL,
  `descricao` VARCHAR(100) NULL,
  `ativo` TINYINT(1) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Fornecedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Fornecedor` (
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
  CONSTRAINT `fk_Fornecedor_1`
    FOREIGN KEY (`id_municipio`)
    REFERENCES `mydb`.`Municipio` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Fornecedor_2`
    FOREIGN KEY (`id_natureza_juridica`)
    REFERENCES `mydb`.`NaturezaJuridica` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Fornecedor_3`
    FOREIGN KEY (`id_porte_empresa`)
    REFERENCES `mydb`.`PorteEmpresa` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Fornecedor_4`
    FOREIGN KEY (`id_ramo_negocio`)
    REFERENCES `mydb`.`RamoNegocio` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`LinhasFornecimento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`LinhasFornecimento` (
  `ativo` TINYINT(1) NULL,
  `codigo_material` VARCHAR(45) NULL,
  `codigo_servico` VARCHAR(45) NULL,
  `id` INT NULL,
  `tipo` VARCHAR(45) NULL)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`TiposOcorrencia`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`TiposOcorrencia` (
  `id` INT NOT NULL,
  `descricao` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`OcorrenciaFornecedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`OcorrenciaFornecedor` (
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
    REFERENCES `mydb`.`Fornecedor` (`cnpj`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_OcorrenciaFornecedor_2`
    FOREIGN KEY (`id_tipo_ocorrencia`)
    REFERENCES `mydb`.`TiposOcorrencia` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`AmbitoOcorrencia`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`AmbitoOcorrencia` (
  `id` INT NOT NULL,
  `descricao` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`PrazoOcorrencia`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`PrazoOcorrencia` (
  `id` INT NOT NULL,
  `descricao` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
