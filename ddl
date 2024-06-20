CREATE TABLE IF NOT EXISTS public.bancos (
    idbanco INTEGER NOT NULL,
    nome VARCHAR(100) NOT NULL,
    CONSTRAINT bancos_pkey PRIMARY KEY (idbanco)
) TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.bancos
    OWNER TO postgres;

CREATE TABLE IF NOT EXISTS public.clientes (
    idcliente INTEGER NOT NULL,
    nome VARCHAR(100) NOT NULL,
    telefone INTEGER NOT NULL,
    email VARCHAR(100) NOT NULL,
    CONSTRAINT clientes_pkey PRIMARY KEY (idcliente)
) TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.clientes
    OWNER TO postgres;

CREATE INDEX IF NOT EXISTS idx_clientes
    ON public.clientes USING btree
    (nome COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE TABLE IF NOT EXISTS public.fornecedores (
    idfornecedor INTEGER NOT NULL,
    nome VARCHAR(100) NOT NULL,
    telefone INTEGER NOT NULL,
    email VARCHAR(100) NOT NULL,
    CONSTRAINT fornecedores_pkey PRIMARY KEY (idfornecedor)
) TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.fornecedores
    OWNER TO postgres;

CREATE TABLE IF NOT EXISTS public.contacorrente (
    idconta INTEGER NOT NULL,
    idbanco INTEGER NOT NULL,
    numeroconta INTEGER NOT NULL,
    digitoconta INTEGER NOT NULL,
    saldoinicial DOUBLE PRECISION NOT NULL,
    saldoatual DOUBLE PRECISION NOT NULL,
    CONSTRAINT contacorrente_pkey PRIMARY KEY (idconta),
    CONSTRAINT fk_contacorrente_banco FOREIGN KEY (idbanco)
        REFERENCES public.bancos (idbanco) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
) TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.contacorrente
    OWNER TO postgres;

CREATE TABLE IF NOT EXISTS public.contaspagar (
    idcontapagar INTEGER NOT NULL,
    parcela INTEGER NOT NULL,
    idfornecedor INTEGER NOT NULL,
    datadigitacao DATE NOT NULL,
    datavencimento DATE NOT NULL,
    valorconta DOUBLE PRECISION NOT NULL,
    status VARCHAR(50) NOT NULL,
    observacao VARCHAR(255) NOT NULL,
    CONSTRAINT contaspagar_pkey PRIMARY KEY (idcontapagar),
    CONSTRAINT fk_contaspagar_fornecedor FOREIGN KEY (idfornecedor)
        REFERENCES public.fornecedores (idfornecedor) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
) TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.contaspagar
    OWNER TO postgres;

CREATE TABLE IF NOT EXISTS public.contasreceber (
    idcontareceber INTEGER NOT NULL,
    parcela INTEGER NOT NULL,
    idcliente INTEGER NOT NULL,
    datadigitacao DATE NOT NULL,
    datavencimento DATE NOT NULL,
    valorconta DOUBLE PRECISION NOT NULL,
    status VARCHAR(50) NOT NULL,
    observacao VARCHAR(255) NOT NULL,
    CONSTRAINT contasreceber_pkey PRIMARY KEY (idcontareceber),
    CONSTRAINT fk_contasreceber_cliente FOREIGN KEY (idcliente)
        REFERENCES public.clientes (idcliente) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
) TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.contasreceber
    OWNER TO postgres;

CREATE INDEX IF NOT EXISTS busca_obs_idx
    ON public.contasreceber USING gin
    (observacao COLLATE pg_catalog."default" gin_trgm_ops)
    TABLESPACE pg_default;

CREATE TABLE IF NOT EXISTS public.movimentofinanceiro (
    idmovto INTEGER NOT NULL,
    datamovto DATE NOT NULL,
    hora TIME WITH TIME ZONE NOT NULL,
    valor DOUBLE PRECISION NOT NULL,
    idrecebimento INTEGER NOT NULL,
    parcela INTEGER NOT NULL,
    tabelaorigem VARCHAR(50) NOT NULL,
    tipo VARCHAR(50),
    CONSTRAINT movimentofinanceiro_pkey PRIMARY KEY (idmovto),
    CONSTRAINT fk_movimentofinanceiro_recebimento FOREIGN KEY (idrecebimento)
        REFERENCES public.recebimentos (idrecebimento) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
) TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.movimentofinanceiro
    OWNER TO postgres;

CREATE TABLE IF NOT EXISTS public.pagamentos (
    idpagamento INTEGER NOT NULL,
    idcontapagar INTEGER NOT NULL,
    parcela INTEGER NOT NULL,
    datapagamento DATE NOT NULL,
    valorpago DOUBLE PRECISION NOT NULL,
    idconta INTEGER NOT NULL,
    CONSTRAINT pagamentos_pkey PRIMARY KEY (idpagamento),
    CONSTRAINT fk_pagamentos_conta FOREIGN KEY (idconta)
        REFERENCES public.contacorrente (idconta) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_pagamentos_contapagar FOREIGN KEY (idcontapagar)
        REFERENCES public.contaspagar (idcontapagar) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
) TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.pagamentos
    OWNER TO postgres;

CREATE TABLE IF NOT EXISTS public.recebimentos (
    idrecebimento INTEGER NOT NULL,
    idcontareceber INTEGER NOT NULL,
    parcela INTEGER NOT NULL,
    datarecebimento DATE NOT NULL,
    valorrecebido DOUBLE PRECISION NOT NULL,
    idconta INTEGER NOT NULL,
    CONSTRAINT recebimentos_pkey PRIMARY KEY (idrecebimento),
    CONSTRAINT fk_recebimentos_conta FOREIGN KEY (idconta)
        REFERENCES public.contacorrente (idconta) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_recebimentos_contareceber FOREIGN KEY (idcontareceber)
        REFERENCES public.contasreceber (idcontareceber) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
) TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.recebimentos
    OWNER TO postgres;
