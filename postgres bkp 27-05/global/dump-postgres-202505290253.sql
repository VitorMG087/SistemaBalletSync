--
-- PostgreSQL database cluster dump
--

-- Started on 2025-05-29 02:53:55

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS;

--
-- User Configurations
--








--
-- Databases
--

--
-- Database "template1" dump
--

\connect template1

--
-- PostgreSQL database dump
--

-- Dumped from database version 17.0
-- Dumped by pg_dump version 17.0

-- Started on 2025-05-29 02:53:55

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

-- Completed on 2025-05-29 02:53:56

--
-- PostgreSQL database dump complete
--

--
-- Database "VarejoDB" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 17.0
-- Dumped by pg_dump version 17.0

-- Started on 2025-05-29 02:53:56

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4841 (class 1262 OID 24579)
-- Name: VarejoDB; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE "VarejoDB" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Portuguese_Brazil.1252';


ALTER DATABASE "VarejoDB" OWNER TO postgres;

\connect "VarejoDB"

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 220 (class 1259 OID 24590)
-- Name: clientes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clientes (
    id integer NOT NULL,
    nome character varying(200) NOT NULL,
    cpf character varying(11) NOT NULL,
    email character varying(250) NOT NULL,
    telefone character varying(11) NOT NULL,
    funcionarioalteracao integer NOT NULL,
    dataalteracao date NOT NULL,
    datacriacao date NOT NULL
);


ALTER TABLE public.clientes OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 24589)
-- Name: clientes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.clientes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.clientes_id_seq OWNER TO postgres;

--
-- TOC entry 4842 (class 0 OID 0)
-- Dependencies: 219
-- Name: clientes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.clientes_id_seq OWNED BY public.clientes.id;


--
-- TOC entry 218 (class 1259 OID 24581)
-- Name: funcionarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.funcionarios (
    id integer NOT NULL,
    login character varying(200) NOT NULL,
    nome character varying(200) NOT NULL,
    senha character varying(200) NOT NULL,
    cargo character varying(200) NOT NULL,
    salario double precision NOT NULL,
    funcionarioalteracao integer NOT NULL,
    dataalteracao date NOT NULL,
    datacriacao date NOT NULL
);


ALTER TABLE public.funcionarios OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 24580)
-- Name: funcionarios_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.funcionarios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.funcionarios_id_seq OWNER TO postgres;

--
-- TOC entry 4843 (class 0 OID 0)
-- Dependencies: 217
-- Name: funcionarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.funcionarios_id_seq OWNED BY public.funcionarios.id;


--
-- TOC entry 225 (class 1259 OID 24634)
-- Name: produto_venda; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.produto_venda (
    venda_fk integer NOT NULL,
    produto_fk integer NOT NULL,
    quantidade integer NOT NULL
);


ALTER TABLE public.produto_venda OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 24621)
-- Name: produtos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.produtos (
    id integer NOT NULL,
    nome character varying(200) NOT NULL,
    preco double precision NOT NULL,
    quantidade integer NOT NULL,
    marca character varying(200) NOT NULL,
    descricao character varying(200) NOT NULL,
    funcionarioalteracao integer NOT NULL,
    dataalteracao date NOT NULL,
    datacriacao date NOT NULL
);


ALTER TABLE public.produtos OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 24620)
-- Name: produtos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.produtos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.produtos_id_seq OWNER TO postgres;

--
-- TOC entry 4844 (class 0 OID 0)
-- Dependencies: 223
-- Name: produtos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.produtos_id_seq OWNED BY public.produtos.id;


--
-- TOC entry 222 (class 1259 OID 24604)
-- Name: vendas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vendas (
    id integer NOT NULL,
    funcionario_fk integer NOT NULL,
    cliente_fk integer NOT NULL,
    data_venda date NOT NULL,
    valor_total double precision NOT NULL,
    forma_pagamento character varying(100)
);


ALTER TABLE public.vendas OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 24603)
-- Name: vendas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.vendas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.vendas_id_seq OWNER TO postgres;

--
-- TOC entry 4845 (class 0 OID 0)
-- Dependencies: 221
-- Name: vendas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.vendas_id_seq OWNED BY public.vendas.id;


--
-- TOC entry 4661 (class 2604 OID 24593)
-- Name: clientes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes ALTER COLUMN id SET DEFAULT nextval('public.clientes_id_seq'::regclass);


--
-- TOC entry 4660 (class 2604 OID 24584)
-- Name: funcionarios id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.funcionarios ALTER COLUMN id SET DEFAULT nextval('public.funcionarios_id_seq'::regclass);


--
-- TOC entry 4663 (class 2604 OID 24624)
-- Name: produtos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produtos ALTER COLUMN id SET DEFAULT nextval('public.produtos_id_seq'::regclass);


--
-- TOC entry 4662 (class 2604 OID 24607)
-- Name: vendas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendas ALTER COLUMN id SET DEFAULT nextval('public.vendas_id_seq'::regclass);


--
-- TOC entry 4830 (class 0 OID 24590)
-- Dependencies: 220
-- Data for Name: clientes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.clientes (id, nome, cpf, email, telefone, funcionarioalteracao, dataalteracao, datacriacao) FROM stdin;
0	JOAO PEDRO	11111111111	JoaoPedroJ@outlook.com	44999362593	0	2024-11-27	2024-11-27
1	ABACCHIO	000	Abacchio@outlook.com	44666999645	1	2024-11-27	2024-11-27
2	TARIC	45956985660	TaricoReiDaGamePlay@outlook.com	44999658535	1	2024-12-09	2024-12-09
3	ZAG	12556548513	ZagZol@outlook.com	44999858746	1	2024-12-09	2024-12-09
4	JOAO GOMES	12345567689	jaogoms@outlook.com	44999362596	1	2024-12-10	2024-12-10
5	TARIC ZONIA	22233344455	Afasoo@oootilç.com	44999362596	1	2024-12-10	2024-12-10
6	GSDGDG	21312312312	rhjrtherthr	44999362593	1	2024-12-10	2024-12-10
7	312312312	123123	12312	44999362593	1	2024-12-10	2024-12-10
8	321312	312312	312312	44999362593	1	2024-12-10	2024-12-10
9	123123	12312	123123	44999362593	1	2024-12-10	2024-12-10
10	312312	1231	321412	44999362593	1	2024-12-10	2024-12-10
11	32352423	12124152	312	44999362593	1	2024-12-10	2024-12-10
12	64564564	64456	645	44999362593	1	2024-12-10	2024-12-10
13	42342	4234	5432	44999362593	1	2024-12-10	2024-12-10
14	31231231	23131	31231	44999362593	1	2024-12-10	2024-12-10
15	2314141	1434634564	785675675675	44999362593	1	2024-12-10	2024-12-10
16	1234242	4234234234	2352245234	44999362593	1	2024-12-10	2024-12-10
17	31231231231	3125141412	41234125234341	44999362593	1	2024-12-10	2024-12-10
18	3121314	41241	567569697	44999362593	1	2024-12-10	2024-12-10
19	423423423623	4145156162	535263426256	44999362593	1	2024-12-10	2024-12-10
20	1231231125	45344534	44999362593	44999362593	1	2024-12-10	2024-12-10
21	3123125654	6456463	3423423	44999362593	1	2024-12-10	2024-12-10
22	523525252	4234262	43634535	44999362593	1	2024-12-10	2024-12-10
23	634574734	3455345	5452562	44999362593	1	2024-12-10	2024-12-10
24	3463454	7645452	32375235	44999362593	1	2024-12-10	2024-12-10
25	7424523637	87636484	784565	44999362593	1	2024-12-10	2024-12-10
26	234234	322612341	2512352	44999362593	1	2024-12-10	2024-12-10
27	2434234	2326654	335425126	44999362593	1	2024-12-10	2024-12-10
28	346322564	5236325264	3424236	44999362593	1	2024-12-10	2024-12-10
29	6734527	678590	958456	44999362593	1	2024-12-10	2024-12-10
30	6522	6706769	9764573	44999362593	1	2024-12-10	2024-12-10
31	785633836	45324633	898645	44999362593	1	2024-12-10	2024-12-10
32	64416234	347233	252342362	44999362593	1	2024-12-10	2024-12-10
33	IGOR MENDES GOMES DA SILVA	231231231	SGWSEKFOAWSEFKOEO	44999362593	1	2024-12-11	2024-12-11
34	VITOR MENDES GOMES DA SILVA	14535	2325234	44999362293	1	2024-12-11	2024-12-11
35		323232	3152	44999362593	1	2024-12-12	2024-12-12
\.


--
-- TOC entry 4828 (class 0 OID 24581)
-- Dependencies: 218
-- Data for Name: funcionarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.funcionarios (id, login, nome, senha, cargo, salario, funcionarioalteracao, dataalteracao, datacriacao) FROM stdin;
0	admin	admin	admin	admin	0	0	2024-11-19	2024-11-19
1	Mendes	IGOR MENDES GOMES	123	GERENTE	2100	0	2024-11-27	2024-11-27
2	Pedro	PEDRO	123	VENDEDOR	1300	1	2024-12-09	2024-12-09
\.


--
-- TOC entry 4835 (class 0 OID 24634)
-- Dependencies: 225
-- Data for Name: produto_venda; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.produto_venda (venda_fk, produto_fk, quantidade) FROM stdin;
\.


--
-- TOC entry 4834 (class 0 OID 24621)
-- Dependencies: 224
-- Data for Name: produtos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.produtos (id, nome, preco, quantidade, marca, descricao, funcionarioalteracao, dataalteracao, datacriacao) FROM stdin;
4	ANTIMATERIA	1e+16	1	COSMETICS	RARO	0	2024-11-27	2024-11-27
0	CUECA	30	5	JONSON	P	0	2024-11-19	2024-11-19
1	CALCA	70	0	JOGGER	M	0	2024-11-22	2024-11-22
2	MACACAO	150	0	NEWBALANCE	M	0	2024-11-26	2024-11-26
5	IA2	15000	1	IMBEL	55,6	1	2024-12-09	2024-12-09
3	BONE	35	2	LOISVITTON	56	0	2024-11-26	2024-11-26
\.


--
-- TOC entry 4832 (class 0 OID 24604)
-- Dependencies: 222
-- Data for Name: vendas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vendas (id, funcionario_fk, cliente_fk, data_venda, valor_total, forma_pagamento) FROM stdin;
0	1	1	2024-12-03	150	CREDITO
1	1	1	2024-12-03	150	CREDITO
2	1	2	2024-12-12	0	PIX
3	1	2	2024-12-12	0	PIX
4	1	1	2024-12-12	0	DINHEIRO
5	1	1	2024-12-12	70	DINHEIRO
\.


--
-- TOC entry 4846 (class 0 OID 0)
-- Dependencies: 219
-- Name: clientes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.clientes_id_seq', 1, false);


--
-- TOC entry 4847 (class 0 OID 0)
-- Dependencies: 217
-- Name: funcionarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.funcionarios_id_seq', 1, false);


--
-- TOC entry 4848 (class 0 OID 0)
-- Dependencies: 223
-- Name: produtos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.produtos_id_seq', 1, false);


--
-- TOC entry 4849 (class 0 OID 0)
-- Dependencies: 221
-- Name: vendas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.vendas_id_seq', 1, false);


--
-- TOC entry 4667 (class 2606 OID 24597)
-- Name: clientes clientes_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_email_key UNIQUE (email);


--
-- TOC entry 4669 (class 2606 OID 24595)
-- Name: clientes clientes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (id);


--
-- TOC entry 4665 (class 2606 OID 24588)
-- Name: funcionarios funcionarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.funcionarios
    ADD CONSTRAINT funcionarios_pkey PRIMARY KEY (id);


--
-- TOC entry 4675 (class 2606 OID 24638)
-- Name: produto_venda produto_venda_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto_venda
    ADD CONSTRAINT produto_venda_pkey PRIMARY KEY (venda_fk, produto_fk);


--
-- TOC entry 4673 (class 2606 OID 24628)
-- Name: produtos produtos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produtos
    ADD CONSTRAINT produtos_pkey PRIMARY KEY (id);


--
-- TOC entry 4671 (class 2606 OID 24609)
-- Name: vendas vendas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT vendas_pkey PRIMARY KEY (id);


--
-- TOC entry 4676 (class 2606 OID 24598)
-- Name: clientes clientes_funcionario_fk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_funcionario_fk_fkey FOREIGN KEY (funcionarioalteracao) REFERENCES public.funcionarios(id);


--
-- TOC entry 4680 (class 2606 OID 24644)
-- Name: produto_venda produto_venda_produto_fk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto_venda
    ADD CONSTRAINT produto_venda_produto_fk_fkey FOREIGN KEY (produto_fk) REFERENCES public.produtos(id);


--
-- TOC entry 4681 (class 2606 OID 24639)
-- Name: produto_venda produto_venda_venda_fk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto_venda
    ADD CONSTRAINT produto_venda_venda_fk_fkey FOREIGN KEY (venda_fk) REFERENCES public.vendas(id);


--
-- TOC entry 4679 (class 2606 OID 24629)
-- Name: produtos produtos_funcionario_fk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produtos
    ADD CONSTRAINT produtos_funcionario_fk_fkey FOREIGN KEY (funcionarioalteracao) REFERENCES public.funcionarios(id);


--
-- TOC entry 4677 (class 2606 OID 24615)
-- Name: vendas vendas_cliente_fk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT vendas_cliente_fk_fkey FOREIGN KEY (cliente_fk) REFERENCES public.clientes(id);


--
-- TOC entry 4678 (class 2606 OID 24610)
-- Name: vendas vendas_funcionario_fk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT vendas_funcionario_fk_fkey FOREIGN KEY (funcionario_fk) REFERENCES public.funcionarios(id);


-- Completed on 2025-05-29 02:53:57

--
-- PostgreSQL database dump complete
--

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

-- Dumped from database version 17.0
-- Dumped by pg_dump version 17.0

-- Started on 2025-05-29 02:53:57

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 218 (class 1259 OID 32772)
-- Name: alunos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alunos (
    id integer NOT NULL,
    nome character varying(255) NOT NULL,
    cpf character(11) NOT NULL,
    telefone character varying(15) NOT NULL,
    cep character varying,
    estado character varying NOT NULL,
    cidade character varying NOT NULL,
    bairro character varying,
    endereco character varying NOT NULL,
    complemento character varying
);


ALTER TABLE public.alunos OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 41004)
-- Name: alunos_aulas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alunos_aulas (
    aluno_id integer NOT NULL,
    aula_id integer NOT NULL
);


ALTER TABLE public.alunos_aulas OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 40993)
-- Name: aulas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.aulas (
    id integer NOT NULL,
    local character varying NOT NULL,
    status_aula integer DEFAULT 1 NOT NULL,
    datahora timestamp without time zone NOT NULL,
    idprofessor integer NOT NULL
);


ALTER TABLE public.aulas OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 40992)
-- Name: aulas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.aulas ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.aulas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 227 (class 1259 OID 49222)
-- Name: despesas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.despesas (
    id integer NOT NULL,
    descricao character varying(255) NOT NULL,
    valor numeric(12,2) NOT NULL,
    data date NOT NULL,
    categoria character varying(100)
);


ALTER TABLE public.despesas OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 49221)
-- Name: despesas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.despesas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.despesas_id_seq OWNER TO postgres;

--
-- TOC entry 4857 (class 0 OID 0)
-- Dependencies: 226
-- Name: despesas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.despesas_id_seq OWNED BY public.despesas.id;


--
-- TOC entry 229 (class 1259 OID 49230)
-- Name: mensalidades; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mensalidades (
    id integer NOT NULL,
    aluno_id integer NOT NULL,
    nome_aluno text NOT NULL,
    valor numeric(10,2) NOT NULL,
    data_vencimento date NOT NULL,
    esta_pago boolean DEFAULT false
);


ALTER TABLE public.mensalidades OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 49229)
-- Name: mensalidades_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.mensalidades_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.mensalidades_id_seq OWNER TO postgres;

--
-- TOC entry 4858 (class 0 OID 0)
-- Dependencies: 228
-- Name: mensalidades_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.mensalidades_id_seq OWNED BY public.mensalidades.id;


--
-- TOC entry 217 (class 1259 OID 32771)
-- Name: pessoas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pessoas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pessoas_id_seq OWNER TO postgres;

--
-- TOC entry 4859 (class 0 OID 0)
-- Dependencies: 217
-- Name: pessoas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pessoas_id_seq OWNED BY public.alunos.id;


--
-- TOC entry 220 (class 1259 OID 40969)
-- Name: professores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.professores (
    id integer NOT NULL,
    nome character varying NOT NULL,
    cpf character varying NOT NULL,
    telefone character varying NOT NULL,
    cep character varying,
    estado character varying NOT NULL,
    cidade character varying NOT NULL,
    bairro character varying NOT NULL,
    endereco character varying NOT NULL,
    complemento character varying
);


ALTER TABLE public.professores OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 40968)
-- Name: professores_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.professores ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.professores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 224 (class 1259 OID 49213)
-- Name: recebimentos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recebimentos (
    id integer NOT NULL,
    descricao character varying(255) NOT NULL,
    valor numeric(12,2) NOT NULL,
    data date NOT NULL,
    categoria character varying(100)
);


ALTER TABLE public.recebimentos OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 49216)
-- Name: recebimentos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.recebimentos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.recebimentos_id_seq OWNER TO postgres;

--
-- TOC entry 4860 (class 0 OID 0)
-- Dependencies: 225
-- Name: recebimentos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.recebimentos_id_seq OWNED BY public.recebimentos.id;


--
-- TOC entry 4670 (class 2604 OID 49217)
-- Name: alunos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alunos ALTER COLUMN id SET DEFAULT nextval('public.pessoas_id_seq'::regclass);


--
-- TOC entry 4673 (class 2604 OID 49225)
-- Name: despesas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.despesas ALTER COLUMN id SET DEFAULT nextval('public.despesas_id_seq'::regclass);


--
-- TOC entry 4674 (class 2604 OID 49233)
-- Name: mensalidades id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mensalidades ALTER COLUMN id SET DEFAULT nextval('public.mensalidades_id_seq'::regclass);


--
-- TOC entry 4672 (class 2604 OID 49218)
-- Name: recebimentos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recebimentos ALTER COLUMN id SET DEFAULT nextval('public.recebimentos_id_seq'::regclass);


--
-- TOC entry 4840 (class 0 OID 32772)
-- Dependencies: 218
-- Data for Name: alunos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alunos (id, nome, cpf, telefone, cep, estado, cidade, bairro, endereco, complemento) FROM stdin;
43	vitor hugo	12345678900	44997146639	07859658	parana	cianorte	zona2	av parana	238
2	Maria Oliveira	23456789012	21988887777	20020000	RJ	Rio de Janeiro	Copacabana	Rua B, 456	Apto 101
4	Ana Santos	45678901234	41966665555	80040000	PR	Curitiba	Batel	Rua D, 101	Casa
45	vitor mendes	87208058111	44991697710	87208075	parana	cianorte	zona 4	rua jade	587
\.


--
-- TOC entry 4845 (class 0 OID 41004)
-- Dependencies: 223
-- Data for Name: alunos_aulas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alunos_aulas (aluno_id, aula_id) FROM stdin;
2	27
2	31
4	27
43	28
43	27
\.


--
-- TOC entry 4844 (class 0 OID 40993)
-- Dependencies: 222
-- Data for Name: aulas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.aulas (id, local, status_aula, datahora, idprofessor) FROM stdin;
22	Casa do Mendes	1	2024-12-05 23:20:51.450082	0
21	casa do mendes	1	2024-12-05 23:06:50.555286	36
24	local1 	1	2024-12-05 23:39:43.42143	0
29	local 4	1	2024-12-08 21:13:29.528752	35
28	local 3	1	2025-05-28 09:12:00	34
27	local 2	1	2025-05-29 09:12:00	32
32	Casa do Mendes	1	2025-05-29 00:41:41.645031	32
31	local4	1	2025-05-28 23:55:00	37
\.


--
-- TOC entry 4849 (class 0 OID 49222)
-- Dependencies: 227
-- Data for Name: despesas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.despesas (id, descricao, valor, data, categoria) FROM stdin;
1	veja para limpeza	150.00	2025-05-29	limpeza
\.


--
-- TOC entry 4851 (class 0 OID 49230)
-- Dependencies: 229
-- Data for Name: mensalidades; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mensalidades (id, aluno_id, nome_aluno, valor, data_vencimento, esta_pago) FROM stdin;
1	1	Ana Silva	350.00	2025-06-05	f
2	2	Carlos Souza	350.00	2025-06-10	f
3	3	Fernanda Lima	350.00	2025-06-12	f
\.


--
-- TOC entry 4842 (class 0 OID 40969)
-- Dependencies: 220
-- Data for Name: professores; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.professores (id, nome, cpf, telefone, cep, estado, cidade, bairro, endereco, complemento) FROM stdin;
37	william	78984564251	44999597710	87209232	parana	cianorte	zona 2	av amazonas	1205
32	bruna	78984564251	44999597710	87209232	parana	cianorte	zona 2	av paraiba	1024
34	bruna	78984564251	44999597710	87209232	parana	cianorte	zona 2	av paraiba	1024
\.


--
-- TOC entry 4846 (class 0 OID 49213)
-- Dependencies: 224
-- Data for Name: recebimentos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recebimentos (id, descricao, valor, data, categoria) FROM stdin;
44	Pagamento referente ao aluno william	435.00	2025-05-29	Mensalidade
45	pagamento de mensalidade referente ao aluno vitor batista	500.00	2025-05-29	Mensalidade
\.


--
-- TOC entry 4861 (class 0 OID 0)
-- Dependencies: 221
-- Name: aulas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.aulas_id_seq', 32, true);


--
-- TOC entry 4862 (class 0 OID 0)
-- Dependencies: 226
-- Name: despesas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.despesas_id_seq', 1, true);


--
-- TOC entry 4863 (class 0 OID 0)
-- Dependencies: 228
-- Name: mensalidades_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.mensalidades_id_seq', 4, true);


--
-- TOC entry 4864 (class 0 OID 0)
-- Dependencies: 217
-- Name: pessoas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pessoas_id_seq', 79, true);


--
-- TOC entry 4865 (class 0 OID 0)
-- Dependencies: 219
-- Name: professores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.professores_id_seq', 38, true);


--
-- TOC entry 4866 (class 0 OID 0)
-- Dependencies: 225
-- Name: recebimentos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.recebimentos_id_seq', 45, true);


--
-- TOC entry 4685 (class 2606 OID 41008)
-- Name: alunos_aulas alunos_aulas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alunos_aulas
    ADD CONSTRAINT alunos_aulas_pkey PRIMARY KEY (aluno_id, aula_id);


--
-- TOC entry 4683 (class 2606 OID 41000)
-- Name: aulas aulas_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aulas
    ADD CONSTRAINT aulas_pk PRIMARY KEY (id);


--
-- TOC entry 4689 (class 2606 OID 49227)
-- Name: despesas despesas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.despesas
    ADD CONSTRAINT despesas_pkey PRIMARY KEY (id);


--
-- TOC entry 4691 (class 2606 OID 49238)
-- Name: mensalidades mensalidades_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mensalidades
    ADD CONSTRAINT mensalidades_pkey PRIMARY KEY (id);


--
-- TOC entry 4677 (class 2606 OID 32779)
-- Name: alunos pessoas_cpf_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alunos
    ADD CONSTRAINT pessoas_cpf_key UNIQUE (cpf);


--
-- TOC entry 4679 (class 2606 OID 32777)
-- Name: alunos pessoas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alunos
    ADD CONSTRAINT pessoas_pkey PRIMARY KEY (id);


--
-- TOC entry 4681 (class 2606 OID 40975)
-- Name: professores professores_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.professores
    ADD CONSTRAINT professores_pk PRIMARY KEY (id);


--
-- TOC entry 4687 (class 2606 OID 49220)
-- Name: recebimentos recebimentos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recebimentos
    ADD CONSTRAINT recebimentos_pkey PRIMARY KEY (id);


--
-- TOC entry 4692 (class 2606 OID 41009)
-- Name: alunos_aulas fk_aluno; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alunos_aulas
    ADD CONSTRAINT fk_aluno FOREIGN KEY (aluno_id) REFERENCES public.alunos(id) ON DELETE CASCADE;


--
-- TOC entry 4693 (class 2606 OID 41014)
-- Name: alunos_aulas fk_aula; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alunos_aulas
    ADD CONSTRAINT fk_aula FOREIGN KEY (aula_id) REFERENCES public.aulas(id) ON DELETE CASCADE;


-- Completed on 2025-05-29 02:53:57

--
-- PostgreSQL database dump complete
--

-- Completed on 2025-05-29 02:53:57

--
-- PostgreSQL database cluster dump complete
--

