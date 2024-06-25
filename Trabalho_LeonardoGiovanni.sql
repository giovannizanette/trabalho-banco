PGDMP  :                    |         	   avaliacao    16.1    16.1 7    n           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            o           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            p           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            q           1262    81930 	   avaliacao    DATABASE     �   CREATE DATABASE avaliacao WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Portuguese_Brazil.1252';
    DROP DATABASE avaliacao;
                postgres    false                        3079    82030    pg_trgm 	   EXTENSION     ;   CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;
    DROP EXTENSION pg_trgm;
                   false            r           0    0    EXTENSION pg_trgm    COMMENT     e   COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';
                        false    2                       1255    98314    atualiza_saldo_conta()    FUNCTION     8  CREATE FUNCTION public.atualiza_saldo_conta() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
        UPDATE public.contacorrente
        SET saldoatual = saldoatual + NEW.valorpago
        WHERE idconta = NEW.idconta;
    END IF;
    RETURN NEW;
END;
$$;
 -   DROP FUNCTION public.atualiza_saldo_conta();
       public          postgres    false            �            1255    82028 @   clientes(integer, character varying, integer, character varying)    FUNCTION       CREATE FUNCTION public.clientes(codigo integer, nome character varying, telefone integer, email character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	insert into clientes (idcliente, nome, telefone, email)
	values (codigo, nome, telefone, email);
END;
$$;
 r   DROP FUNCTION public.clientes(codigo integer, nome character varying, telefone integer, email character varying);
       public          postgres    false                       1255    82112 U   contacorrente(integer, integer, integer, integer, double precision, double precision)    FUNCTION     �  CREATE FUNCTION public.contacorrente(codigo integer, idbanco integer, numeroconta integer, digitoconta integer, saldoinicial double precision, saldoatual double precision) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	insert into clientes (idconta, idbanco, numeroconta, digitoconta, saldoinicial, saldoatual)
	values (codigo, idbanco, numeroconta, digitoconta, saldoinicial, saldoatual);
END;
$$;
 �   DROP FUNCTION public.contacorrente(codigo integer, idbanco integer, numeroconta integer, digitoconta integer, saldoinicial double precision, saldoatual double precision);
       public          postgres    false                       1255    82113 l   contasreceber(integer, integer, integer, date, date, double precision, character varying, character varying)    FUNCTION     <  CREATE FUNCTION public.contasreceber(codigo integer, parcela integer, idcliente integer, datadigitacao date, datavencimento date, valorconta double precision, status character varying, obs character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	insert into contasreceber (idcontareceber, parcela, idcliente, datadigitacao, datavencimento, valorconta, status, observacao)
	values (codigo, parcela, idcliente, datadigitacao, datavencimento, valorconta, status, obs);
	if (status='Aberto') then
			update contareceber set status='Recebido';
			end if;
END;
$$;
 �   DROP FUNCTION public.contasreceber(codigo integer, parcela integer, idcliente integer, datadigitacao date, datavencimento date, valorconta double precision, status character varying, obs character varying);
       public          postgres    false                       1255    98315    insere_movimento_financeiro()    FUNCTION     }  CREATE FUNCTION public.insere_movimento_financeiro() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO public.movimentofinanceiro (idmovto, datamovto, hora, valor, idrecebimento, parcela, tabelaorigem, tipo)
    VALUES (NEW.idpagamento, CURRENT_DATE, CURRENT_TIME, NEW.valorpago, NEW.idcontapagar, NEW.parcela, 'pagamentos', 'débito');
    RETURN NEW;
END;
$$;
 4   DROP FUNCTION public.insere_movimento_financeiro();
       public          postgres    false                       1255    98316    insere_recebimento_financeiro()    FUNCTION     �  CREATE FUNCTION public.insere_recebimento_financeiro() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO public.movimentofinanceiro (idmovto, datamovto, hora, valor, idrecebimento, parcela, tabelaorigem, tipo)
    VALUES (NEW.idrecebimento, CURRENT_DATE, CURRENT_TIME, NEW.valorrecebido, NEW.idcontareceber, NEW.parcela, 'recebimentos', 'crédito');
    RETURN NEW;
END;
$$;
 6   DROP FUNCTION public.insere_recebimento_financeiro();
       public          postgres    false            �            1259    81931    bancos    TABLE     b   CREATE TABLE public.bancos (
    idbanco integer NOT NULL,
    nome character varying NOT NULL
);
    DROP TABLE public.bancos;
       public         heap    postgres    false            �            1259    81938    clientes    TABLE     �   CREATE TABLE public.clientes (
    idcliente integer NOT NULL,
    nome character varying NOT NULL,
    telefone integer NOT NULL,
    email character varying NOT NULL
);
    DROP TABLE public.clientes;
       public         heap    postgres    false            �            1259    81952    contacorrente    TABLE     �   CREATE TABLE public.contacorrente (
    idconta integer NOT NULL,
    idbanco integer NOT NULL,
    numeroconta integer NOT NULL,
    digitoconta integer NOT NULL,
    saldoinicial double precision NOT NULL,
    saldoatual double precision NOT NULL
);
 !   DROP TABLE public.contacorrente;
       public         heap    postgres    false            �            1259    81962    contaspagar    TABLE     G  CREATE TABLE public.contaspagar (
    idcontapagar integer NOT NULL,
    parcela integer NOT NULL,
    idfornecedor integer NOT NULL,
    datadigitacao date NOT NULL,
    datavencimento date NOT NULL,
    valorconta double precision NOT NULL,
    status character varying NOT NULL,
    observacao character varying NOT NULL
);
    DROP TABLE public.contaspagar;
       public         heap    postgres    false            �            1259    81989    contasreceber    TABLE     H  CREATE TABLE public.contasreceber (
    idcontareceber integer NOT NULL,
    parcela integer NOT NULL,
    idcliente integer NOT NULL,
    datadigitacao date NOT NULL,
    datavencimento date NOT NULL,
    valorconta double precision NOT NULL,
    status character varying NOT NULL,
    observacao character varying NOT NULL
);
 !   DROP TABLE public.contasreceber;
       public         heap    postgres    false            �            1259    81945    fornecedores    TABLE     �   CREATE TABLE public.fornecedores (
    idfornecedor integer NOT NULL,
    nome character varying NOT NULL,
    telefone integer NOT NULL,
    email character varying NOT NULL
);
     DROP TABLE public.fornecedores;
       public         heap    postgres    false            �            1259    82016    movimentofinanceiro    TABLE     >  CREATE TABLE public.movimentofinanceiro (
    idmovto integer NOT NULL,
    datamovto date NOT NULL,
    hora time with time zone NOT NULL,
    valor double precision NOT NULL,
    idrecebimento integer NOT NULL,
    parcela integer NOT NULL,
    tabelaorigem character varying NOT NULL,
    tipo character varying
);
 '   DROP TABLE public.movimentofinanceiro;
       public         heap    postgres    false            �            1259    81974 
   pagamentos    TABLE     �   CREATE TABLE public.pagamentos (
    idpagamento integer NOT NULL,
    idcontapagar integer NOT NULL,
    parcela integer NOT NULL,
    datapagamento date NOT NULL,
    valorpago double precision NOT NULL,
    idconta integer NOT NULL
);
    DROP TABLE public.pagamentos;
       public         heap    postgres    false            �            1259    82001    recebimentos    TABLE     �   CREATE TABLE public.recebimentos (
    idrecebimento integer NOT NULL,
    idcontareceber integer NOT NULL,
    parcela integer NOT NULL,
    datarecebimento date NOT NULL,
    valorrecebido double precision NOT NULL,
    idconta integer NOT NULL
);
     DROP TABLE public.recebimentos;
       public         heap    postgres    false            �            1259    98324    vw_contas_pagar    VIEW     *  CREATE VIEW public.vw_contas_pagar AS
 SELECT p.idcontapagar,
    f.nome AS fornecedor,
    p.parcela,
    p.datadigitacao,
    p.datavencimento,
    p.valorconta,
    p.status,
    p.observacao
   FROM (public.contaspagar p
     JOIN public.fornecedores f ON ((p.idfornecedor = f.idfornecedor)));
 "   DROP VIEW public.vw_contas_pagar;
       public          postgres    false    220    220    220    220    220    220    220    218    218    220            �            1259    98328    vw_contas_receber    VIEW     #  CREATE VIEW public.vw_contas_receber AS
 SELECT r.idcontareceber,
    c.nome AS cliente,
    r.parcela,
    r.datadigitacao,
    r.datavencimento,
    r.valorconta,
    r.status,
    r.observacao
   FROM (public.contasreceber r
     JOIN public.clientes c ON ((r.idcliente = c.idcliente)));
 $   DROP VIEW public.vw_contas_receber;
       public          postgres    false    222    217    222    222    222    222    222    222    217    222            �            1259    98320    vw_saldo_contas    VIEW     �   CREATE VIEW public.vw_saldo_contas AS
 SELECT c.idconta,
    b.nome AS banco,
    c.numeroconta,
    c.digitoconta,
    c.saldoatual
   FROM (public.contacorrente c
     JOIN public.bancos b ON ((c.idbanco = b.idbanco)));
 "   DROP VIEW public.vw_saldo_contas;
       public          postgres    false    219    219    219    216    219    219    216            c          0    81931    bancos 
   TABLE DATA           /   COPY public.bancos (idbanco, nome) FROM stdin;
    public          postgres    false    216   oP       d          0    81938    clientes 
   TABLE DATA           D   COPY public.clientes (idcliente, nome, telefone, email) FROM stdin;
    public          postgres    false    217   �P       f          0    81952    contacorrente 
   TABLE DATA           m   COPY public.contacorrente (idconta, idbanco, numeroconta, digitoconta, saldoinicial, saldoatual) FROM stdin;
    public          postgres    false    219   �P       g          0    81962    contaspagar 
   TABLE DATA           �   COPY public.contaspagar (idcontapagar, parcela, idfornecedor, datadigitacao, datavencimento, valorconta, status, observacao) FROM stdin;
    public          postgres    false    220   �P       i          0    81989    contasreceber 
   TABLE DATA           �   COPY public.contasreceber (idcontareceber, parcela, idcliente, datadigitacao, datavencimento, valorconta, status, observacao) FROM stdin;
    public          postgres    false    222   Q       e          0    81945    fornecedores 
   TABLE DATA           K   COPY public.fornecedores (idfornecedor, nome, telefone, email) FROM stdin;
    public          postgres    false    218   7Q       k          0    82016    movimentofinanceiro 
   TABLE DATA           z   COPY public.movimentofinanceiro (idmovto, datamovto, hora, valor, idrecebimento, parcela, tabelaorigem, tipo) FROM stdin;
    public          postgres    false    224   TQ       h          0    81974 
   pagamentos 
   TABLE DATA           k   COPY public.pagamentos (idpagamento, idcontapagar, parcela, datapagamento, valorpago, idconta) FROM stdin;
    public          postgres    false    221   qQ       j          0    82001    recebimentos 
   TABLE DATA           w   COPY public.recebimentos (idrecebimento, idcontareceber, parcela, datarecebimento, valorrecebido, idconta) FROM stdin;
    public          postgres    false    223   �Q       �           2606    81937    bancos bancos_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public.bancos
    ADD CONSTRAINT bancos_pkey PRIMARY KEY (idbanco);
 <   ALTER TABLE ONLY public.bancos DROP CONSTRAINT bancos_pkey;
       public            postgres    false    216            �           2606    81944    clientes clientes_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (idcliente);
 @   ALTER TABLE ONLY public.clientes DROP CONSTRAINT clientes_pkey;
       public            postgres    false    217            �           2606    81956     contacorrente contacorrente_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.contacorrente
    ADD CONSTRAINT contacorrente_pkey PRIMARY KEY (idconta);
 J   ALTER TABLE ONLY public.contacorrente DROP CONSTRAINT contacorrente_pkey;
       public            postgres    false    219            �           2606    81968    contaspagar contaspagar_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.contaspagar
    ADD CONSTRAINT contaspagar_pkey PRIMARY KEY (idcontapagar);
 F   ALTER TABLE ONLY public.contaspagar DROP CONSTRAINT contaspagar_pkey;
       public            postgres    false    220            �           2606    81995     contasreceber contasreceber_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public.contasreceber
    ADD CONSTRAINT contasreceber_pkey PRIMARY KEY (idcontareceber);
 J   ALTER TABLE ONLY public.contasreceber DROP CONSTRAINT contasreceber_pkey;
       public            postgres    false    222            �           2606    81951    fornecedores fornecedores_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.fornecedores
    ADD CONSTRAINT fornecedores_pkey PRIMARY KEY (idfornecedor);
 H   ALTER TABLE ONLY public.fornecedores DROP CONSTRAINT fornecedores_pkey;
       public            postgres    false    218            �           2606    82022 ,   movimentofinanceiro movimentofinanceiro_pkey 
   CONSTRAINT     o   ALTER TABLE ONLY public.movimentofinanceiro
    ADD CONSTRAINT movimentofinanceiro_pkey PRIMARY KEY (idmovto);
 V   ALTER TABLE ONLY public.movimentofinanceiro DROP CONSTRAINT movimentofinanceiro_pkey;
       public            postgres    false    224            �           2606    81978    pagamentos pagamentos_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.pagamentos
    ADD CONSTRAINT pagamentos_pkey PRIMARY KEY (idpagamento);
 D   ALTER TABLE ONLY public.pagamentos DROP CONSTRAINT pagamentos_pkey;
       public            postgres    false    221            �           2606    82005    recebimentos recebimentos_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY public.recebimentos
    ADD CONSTRAINT recebimentos_pkey PRIMARY KEY (idrecebimento);
 H   ALTER TABLE ONLY public.recebimentos DROP CONSTRAINT recebimentos_pkey;
       public            postgres    false    223            �           1259    82111    busca_obs_idx    INDEX     _   CREATE INDEX busca_obs_idx ON public.contasreceber USING gin (observacao public.gin_trgm_ops);
 !   DROP INDEX public.busca_obs_idx;
       public            postgres    false    2    2    2    2    2    2    2    2    2    2    2    2    222            �           1259    82029    idx_clientes    INDEX     A   CREATE INDEX idx_clientes ON public.clientes USING btree (nome);
     DROP INDEX public.idx_clientes;
       public            postgres    false    217            �           2620    98317 #   pagamentos trg_atualiza_saldo_conta    TRIGGER     �   CREATE TRIGGER trg_atualiza_saldo_conta AFTER INSERT OR UPDATE ON public.pagamentos FOR EACH ROW EXECUTE FUNCTION public.atualiza_saldo_conta();
 <   DROP TRIGGER trg_atualiza_saldo_conta ON public.pagamentos;
       public          postgres    false    261    221            �           2620    98318 *   pagamentos trg_insere_movimento_financeiro    TRIGGER     �   CREATE TRIGGER trg_insere_movimento_financeiro AFTER INSERT ON public.pagamentos FOR EACH ROW EXECUTE FUNCTION public.insere_movimento_financeiro();
 C   DROP TRIGGER trg_insere_movimento_financeiro ON public.pagamentos;
       public          postgres    false    221    262            �           2620    98319 .   recebimentos trg_insere_recebimento_financeiro    TRIGGER     �   CREATE TRIGGER trg_insere_recebimento_financeiro AFTER INSERT ON public.recebimentos FOR EACH ROW EXECUTE FUNCTION public.insere_recebimento_financeiro();
 G   DROP TRIGGER trg_insere_recebimento_financeiro ON public.recebimentos;
       public          postgres    false    223    263            �           2606    81957    contacorrente idbanco    FK CONSTRAINT     z   ALTER TABLE ONLY public.contacorrente
    ADD CONSTRAINT idbanco FOREIGN KEY (idbanco) REFERENCES public.bancos(idbanco);
 ?   ALTER TABLE ONLY public.contacorrente DROP CONSTRAINT idbanco;
       public          postgres    false    4787    216    219            �           2606    81996    contasreceber idcliente    FK CONSTRAINT     �   ALTER TABLE ONLY public.contasreceber
    ADD CONSTRAINT idcliente FOREIGN KEY (idcliente) REFERENCES public.clientes(idcliente);
 A   ALTER TABLE ONLY public.contasreceber DROP CONSTRAINT idcliente;
       public          postgres    false    222    217    4789            �           2606    81984    pagamentos idconta    FK CONSTRAINT     ~   ALTER TABLE ONLY public.pagamentos
    ADD CONSTRAINT idconta FOREIGN KEY (idconta) REFERENCES public.contacorrente(idconta);
 <   ALTER TABLE ONLY public.pagamentos DROP CONSTRAINT idconta;
       public          postgres    false    4794    219    221            �           2606    82011    recebimentos idconta    FK CONSTRAINT     �   ALTER TABLE ONLY public.recebimentos
    ADD CONSTRAINT idconta FOREIGN KEY (idconta) REFERENCES public.contacorrente(idconta);
 >   ALTER TABLE ONLY public.recebimentos DROP CONSTRAINT idconta;
       public          postgres    false    219    223    4794            �           2606    81979    pagamentos idcontapagar    FK CONSTRAINT     �   ALTER TABLE ONLY public.pagamentos
    ADD CONSTRAINT idcontapagar FOREIGN KEY (idcontapagar) REFERENCES public.contaspagar(idcontapagar);
 A   ALTER TABLE ONLY public.pagamentos DROP CONSTRAINT idcontapagar;
       public          postgres    false    4796    221    220            �           2606    82006    recebimentos idcontareceber    FK CONSTRAINT     �   ALTER TABLE ONLY public.recebimentos
    ADD CONSTRAINT idcontareceber FOREIGN KEY (idcontareceber) REFERENCES public.contasreceber(idcontareceber);
 E   ALTER TABLE ONLY public.recebimentos DROP CONSTRAINT idcontareceber;
       public          postgres    false    223    222    4801            �           2606    81969    contaspagar idfornecedor    FK CONSTRAINT     �   ALTER TABLE ONLY public.contaspagar
    ADD CONSTRAINT idfornecedor FOREIGN KEY (idfornecedor) REFERENCES public.fornecedores(idfornecedor);
 B   ALTER TABLE ONLY public.contaspagar DROP CONSTRAINT idfornecedor;
       public          postgres    false    218    220    4792            �           2606    82023 !   movimentofinanceiro idrecebimento    FK CONSTRAINT     �   ALTER TABLE ONLY public.movimentofinanceiro
    ADD CONSTRAINT idrecebimento FOREIGN KEY (idrecebimento) REFERENCES public.recebimentos(idrecebimento);
 K   ALTER TABLE ONLY public.movimentofinanceiro DROP CONSTRAINT idrecebimento;
       public          postgres    false    224    4803    223            c   D   x�3�tJ�K�WH�Wp*J,���2�tN̬HTpM��;�%739Q�-5%�(1�˘�&%�89�+F��� i�]      d      x������ � �      f      x������ � �      g      x������ � �      i      x������ � �      e      x������ � �      k      x������ � �      h      x������ � �      j      x������ � �     