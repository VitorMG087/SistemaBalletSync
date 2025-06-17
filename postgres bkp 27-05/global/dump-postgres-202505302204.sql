--
-- PostgreSQL database cluster dump
--

-- Started on 2025-05-30 22:04:43

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

-- Dumped from database version 15.2
-- Dumped by pg_dump version 17.4

-- Started on 2025-05-30 22:04:43

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

-- Completed on 2025-05-30 22:04:43

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

-- Dumped from database version 15.2
-- Dumped by pg_dump version 17.4

-- Started on 2025-05-30 22:04:44

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
-- TOC entry 2 (class 3079 OID 16384)
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- TOC entry 3387 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 215 (class 1259 OID 16398)
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
    complemento character varying,
    tipo_plano character varying(50),
    valor_plano numeric(10,2)
);


ALTER TABLE public.alunos OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 16403)
-- Name: alunos_aulas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alunos_aulas (
    aluno_id integer NOT NULL,
    aula_id integer NOT NULL
);


ALTER TABLE public.alunos_aulas OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16406)
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
-- TOC entry 218 (class 1259 OID 16412)
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
-- TOC entry 219 (class 1259 OID 16413)
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
-- TOC entry 220 (class 1259 OID 16416)
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
-- TOC entry 3388 (class 0 OID 0)
-- Dependencies: 220
-- Name: despesas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.despesas_id_seq OWNED BY public.despesas.id;


--
-- TOC entry 221 (class 1259 OID 16417)
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
-- TOC entry 222 (class 1259 OID 16423)
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
-- TOC entry 3389 (class 0 OID 0)
-- Dependencies: 222
-- Name: mensalidades_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.mensalidades_id_seq OWNED BY public.mensalidades.id;


--
-- TOC entry 223 (class 1259 OID 16424)
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
-- TOC entry 3390 (class 0 OID 0)
-- Dependencies: 223
-- Name: pessoas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pessoas_id_seq OWNED BY public.alunos.id;


--
-- TOC entry 224 (class 1259 OID 16425)
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
-- TOC entry 225 (class 1259 OID 16430)
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
-- TOC entry 226 (class 1259 OID 16431)
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
-- TOC entry 227 (class 1259 OID 16434)
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
-- TOC entry 3391 (class 0 OID 0)
-- Dependencies: 227
-- Name: recebimentos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.recebimentos_id_seq OWNED BY public.recebimentos.id;


--
-- TOC entry 3203 (class 2604 OID 16435)
-- Name: alunos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alunos ALTER COLUMN id SET DEFAULT nextval('public.pessoas_id_seq'::regclass);


--
-- TOC entry 3205 (class 2604 OID 16436)
-- Name: despesas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.despesas ALTER COLUMN id SET DEFAULT nextval('public.despesas_id_seq'::regclass);


--
-- TOC entry 3206 (class 2604 OID 16437)
-- Name: mensalidades id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mensalidades ALTER COLUMN id SET DEFAULT nextval('public.mensalidades_id_seq'::regclass);


--
-- TOC entry 3208 (class 2604 OID 16438)
-- Name: recebimentos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recebimentos ALTER COLUMN id SET DEFAULT nextval('public.recebimentos_id_seq'::regclass);


--
-- TOC entry 3369 (class 0 OID 16398)
-- Dependencies: 215
-- Data for Name: alunos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alunos (id, nome, cpf, telefone, cep, estado, cidade, bairro, endereco, complemento, tipo_plano, valor_plano) FROM stdin;
2	Maria Oliveira	23456789015	21988887777	20020000	RJ	Rio de Janeiro	Copacabana	Rua B, 456	Apto 101	Semestral	0.00
4	Ana Santos	45678901234	41966665555	80040000	PR	Curitiba	Batel	Rua D, 101	Casa	Mensal	0.00
45	vitor mendes	87208058113	44991697710	87208075	parana	cianorte	zona 4	rua jade	587	Semestral	600.00
43	vitor hugo	12345678904	44997146639	07859658	parana	cianorte	zona2	av parana	238	Semestral	600.00
82	tester	11111111111	8888888888	88888888	ADASD	dfaasda	qweqweq	weqweqweqw	wqeqwe	Semestral	600.00
81	tester	11111111112	8888888888	88888888	ADASD	dfaasda	qweqweq	weqweqweqw	wqeqwe	Semestral	600.00
\.


--
-- TOC entry 3370 (class 0 OID 16403)
-- Dependencies: 216
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
-- TOC entry 3371 (class 0 OID 16406)
-- Dependencies: 217
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
-- TOC entry 3373 (class 0 OID 16413)
-- Dependencies: 219
-- Data for Name: despesas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.despesas (id, descricao, valor, data, categoria) FROM stdin;
1	veja para limpeza	150.00	2025-05-29	limpeza
\.


--
-- TOC entry 3375 (class 0 OID 16417)
-- Dependencies: 221
-- Data for Name: mensalidades; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mensalidades (id, aluno_id, nome_aluno, valor, data_vencimento, esta_pago) FROM stdin;
1	1	Ana Silva	350.00	2025-06-05	t
3	3	Fernanda Lima	350.00	2025-06-12	t
2	2	Carlos Souza	350.00	2025-06-10	t
\.


--
-- TOC entry 3378 (class 0 OID 16425)
-- Dependencies: 224
-- Data for Name: professores; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.professores (id, nome, cpf, telefone, cep, estado, cidade, bairro, endereco, complemento) FROM stdin;
37	william	78984564251	44999597710	87209232	parana	cianorte	zona 2	av amazonas	1205
32	bruna	78984564251	44999597710	87209232	parana	cianorte	zona 2	av paraiba	1024
34	bruna	78984564251	44999597710	87209232	parana	cianorte	zona 2	av paraiba	1024
\.


--
-- TOC entry 3380 (class 0 OID 16431)
-- Dependencies: 226
-- Data for Name: recebimentos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recebimentos (id, descricao, valor, data, categoria) FROM stdin;
\.


--
-- TOC entry 3392 (class 0 OID 0)
-- Dependencies: 218
-- Name: aulas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.aulas_id_seq', 32, true);


--
-- TOC entry 3393 (class 0 OID 0)
-- Dependencies: 220
-- Name: despesas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.despesas_id_seq', 1, true);


--
-- TOC entry 3394 (class 0 OID 0)
-- Dependencies: 222
-- Name: mensalidades_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.mensalidades_id_seq', 4, true);


--
-- TOC entry 3395 (class 0 OID 0)
-- Dependencies: 223
-- Name: pessoas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pessoas_id_seq', 82, true);


--
-- TOC entry 3396 (class 0 OID 0)
-- Dependencies: 225
-- Name: professores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.professores_id_seq', 38, true);


--
-- TOC entry 3397 (class 0 OID 0)
-- Dependencies: 227
-- Name: recebimentos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.recebimentos_id_seq', 51, true);


--
-- TOC entry 3214 (class 2606 OID 16440)
-- Name: alunos_aulas alunos_aulas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alunos_aulas
    ADD CONSTRAINT alunos_aulas_pkey PRIMARY KEY (aluno_id, aula_id);


--
-- TOC entry 3216 (class 2606 OID 16442)
-- Name: aulas aulas_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aulas
    ADD CONSTRAINT aulas_pk PRIMARY KEY (id);


--
-- TOC entry 3218 (class 2606 OID 16444)
-- Name: despesas despesas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.despesas
    ADD CONSTRAINT despesas_pkey PRIMARY KEY (id);


--
-- TOC entry 3220 (class 2606 OID 16446)
-- Name: mensalidades mensalidades_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mensalidades
    ADD CONSTRAINT mensalidades_pkey PRIMARY KEY (id);


--
-- TOC entry 3210 (class 2606 OID 16448)
-- Name: alunos pessoas_cpf_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alunos
    ADD CONSTRAINT pessoas_cpf_key UNIQUE (cpf);


--
-- TOC entry 3212 (class 2606 OID 16450)
-- Name: alunos pessoas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alunos
    ADD CONSTRAINT pessoas_pkey PRIMARY KEY (id);


--
-- TOC entry 3222 (class 2606 OID 16452)
-- Name: professores professores_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.professores
    ADD CONSTRAINT professores_pk PRIMARY KEY (id);


--
-- TOC entry 3224 (class 2606 OID 16454)
-- Name: recebimentos recebimentos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recebimentos
    ADD CONSTRAINT recebimentos_pkey PRIMARY KEY (id);


--
-- TOC entry 3225 (class 2606 OID 16455)
-- Name: alunos_aulas fk_aluno; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alunos_aulas
    ADD CONSTRAINT fk_aluno FOREIGN KEY (aluno_id) REFERENCES public.alunos(id) ON DELETE CASCADE;


--
-- TOC entry 3226 (class 2606 OID 16460)
-- Name: alunos_aulas fk_aula; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alunos_aulas
    ADD CONSTRAINT fk_aula FOREIGN KEY (aula_id) REFERENCES public.aulas(id) ON DELETE CASCADE;


-- Completed on 2025-05-30 22:04:44

--
-- PostgreSQL database dump complete
--

-- Completed on 2025-05-30 22:04:44

--
-- PostgreSQL database cluster dump complete
--

