PGDMP                      }            postgres    15.2    17.4 %    #           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false            $           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false            %           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false            &           1262    5    postgres    DATABASE        CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Portuguese_Brazil.1252';
    DROP DATABASE postgres;
                     postgres    false            '           0    0    DATABASE postgres    COMMENT     N   COMMENT ON DATABASE postgres IS 'default administrative connection database';
                        postgres    false    3366                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
                     pg_database_owner    false            (           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                        pg_database_owner    false    5            �            1259    16398    alunos    TABLE     �  CREATE TABLE public.alunos (
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
    DROP TABLE public.alunos;
       public         heap r       postgres    false    5            �            1259    16403    alunos_aulas    TABLE     b   CREATE TABLE public.alunos_aulas (
    aluno_id integer NOT NULL,
    aula_id integer NOT NULL
);
     DROP TABLE public.alunos_aulas;
       public         heap r       postgres    false    5            �            1259    16406    aulas    TABLE     �   CREATE TABLE public.aulas (
    id integer NOT NULL,
    local character varying NOT NULL,
    status_aula integer DEFAULT 1 NOT NULL,
    datahora timestamp without time zone NOT NULL,
    idprofessor integer NOT NULL
);
    DROP TABLE public.aulas;
       public         heap r       postgres    false    5            �            1259    16412    aulas_id_seq    SEQUENCE     �   ALTER TABLE public.aulas ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.aulas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public               postgres    false    217    5            �            1259    16413    pessoas_id_seq    SEQUENCE     �   CREATE SEQUENCE public.pessoas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.pessoas_id_seq;
       public               postgres    false    215    5            )           0    0    pessoas_id_seq    SEQUENCE OWNED BY     @   ALTER SEQUENCE public.pessoas_id_seq OWNED BY public.alunos.id;
          public               postgres    false    219            �            1259    16414    professores    TABLE     �  CREATE TABLE public.professores (
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
    DROP TABLE public.professores;
       public         heap r       postgres    false    5            �            1259    16419    professores_id_seq    SEQUENCE     �   ALTER TABLE public.professores ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.professores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public               postgres    false    220    5            �            1259    16463    recebimentos    TABLE     �   CREATE TABLE public.recebimentos (
    id integer NOT NULL,
    descricao character varying(255) NOT NULL,
    valor numeric(12,2) NOT NULL,
    data date NOT NULL,
    categoria character varying(100)
);
     DROP TABLE public.recebimentos;
       public         heap r       postgres    false    5            �            1259    16462    recebimentos_id_seq    SEQUENCE     �   CREATE SEQUENCE public.recebimentos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.recebimentos_id_seq;
       public               postgres    false    223    5            *           0    0    recebimentos_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.recebimentos_id_seq OWNED BY public.recebimentos.id;
          public               postgres    false    222            y           2604    16420 	   alunos id    DEFAULT     g   ALTER TABLE ONLY public.alunos ALTER COLUMN id SET DEFAULT nextval('public.pessoas_id_seq'::regclass);
 8   ALTER TABLE public.alunos ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    219    215            {           2604    16466    recebimentos id    DEFAULT     r   ALTER TABLE ONLY public.recebimentos ALTER COLUMN id SET DEFAULT nextval('public.recebimentos_id_seq'::regclass);
 >   ALTER TABLE public.recebimentos ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    222    223    223                      0    16398    alunos 
   TABLE DATA           m   COPY public.alunos (id, nome, cpf, telefone, cep, estado, cidade, bairro, endereco, complemento) FROM stdin;
    public               postgres    false    215   =*                 0    16403    alunos_aulas 
   TABLE DATA           9   COPY public.alunos_aulas (aluno_id, aula_id) FROM stdin;
    public               postgres    false    216   =+                 0    16406    aulas 
   TABLE DATA           N   COPY public.aulas (id, local, status_aula, datahora, idprofessor) FROM stdin;
    public               postgres    false    217   q+                 0    16414    professores 
   TABLE DATA           r   COPY public.professores (id, nome, cpf, telefone, cep, estado, cidade, bairro, endereco, complemento) FROM stdin;
    public               postgres    false    220    ,                  0    16463    recebimentos 
   TABLE DATA           M   COPY public.recebimentos (id, descricao, valor, data, categoria) FROM stdin;
    public               postgres    false    223   �,       +           0    0    aulas_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.aulas_id_seq', 31, true);
          public               postgres    false    218            ,           0    0    pessoas_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.pessoas_id_seq', 78, true);
          public               postgres    false    219            -           0    0    professores_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.professores_id_seq', 38, true);
          public               postgres    false    221            .           0    0    recebimentos_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.recebimentos_id_seq', 15, true);
          public               postgres    false    222            �           2606    16422    alunos_aulas alunos_aulas_pkey 
   CONSTRAINT     k   ALTER TABLE ONLY public.alunos_aulas
    ADD CONSTRAINT alunos_aulas_pkey PRIMARY KEY (aluno_id, aula_id);
 H   ALTER TABLE ONLY public.alunos_aulas DROP CONSTRAINT alunos_aulas_pkey;
       public                 postgres    false    216    216            �           2606    16424    aulas aulas_pk 
   CONSTRAINT     L   ALTER TABLE ONLY public.aulas
    ADD CONSTRAINT aulas_pk PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.aulas DROP CONSTRAINT aulas_pk;
       public                 postgres    false    217            }           2606    16426    alunos pessoas_cpf_key 
   CONSTRAINT     P   ALTER TABLE ONLY public.alunos
    ADD CONSTRAINT pessoas_cpf_key UNIQUE (cpf);
 @   ALTER TABLE ONLY public.alunos DROP CONSTRAINT pessoas_cpf_key;
       public                 postgres    false    215                       2606    16428    alunos pessoas_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.alunos
    ADD CONSTRAINT pessoas_pkey PRIMARY KEY (id);
 =   ALTER TABLE ONLY public.alunos DROP CONSTRAINT pessoas_pkey;
       public                 postgres    false    215            �           2606    16430    professores professores_pk 
   CONSTRAINT     X   ALTER TABLE ONLY public.professores
    ADD CONSTRAINT professores_pk PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.professores DROP CONSTRAINT professores_pk;
       public                 postgres    false    220            �           2606    16468    recebimentos recebimentos_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.recebimentos
    ADD CONSTRAINT recebimentos_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.recebimentos DROP CONSTRAINT recebimentos_pkey;
       public                 postgres    false    223            �           2606    16431    alunos_aulas fk_aluno    FK CONSTRAINT     �   ALTER TABLE ONLY public.alunos_aulas
    ADD CONSTRAINT fk_aluno FOREIGN KEY (aluno_id) REFERENCES public.alunos(id) ON DELETE CASCADE;
 ?   ALTER TABLE ONLY public.alunos_aulas DROP CONSTRAINT fk_aluno;
       public               postgres    false    215    216    3199            �           2606    16436    alunos_aulas fk_aula    FK CONSTRAINT     �   ALTER TABLE ONLY public.alunos_aulas
    ADD CONSTRAINT fk_aula FOREIGN KEY (aula_id) REFERENCES public.aulas(id) ON DELETE CASCADE;
 >   ALTER TABLE ONLY public.alunos_aulas DROP CONSTRAINT fk_aula;
       public               postgres    false    217    216    3203               �   x�mлn�0���+�A!�z��;(Z�k&Z�eȏ�__�02��	Tx������S!�F�|RA��k\���@wF�2�#?�PW2�<ҕ.4�����+��8g.�dǁ�;s���-��15�B���.%��B8�o��|�Shi"��4�����	�)��RJh���9)��3��o�&r�#~s�G�T�����͎~-�����Njk� �	��IZ�>P�gO��?M\�         $   x�3�42�2�46�2�L�9�,�$������ c�"         �   x�m�=�0��>E.��~��&+37`��[���K��B�`��@��5��3���mz��Y"����$����H�BJD`��:�������j������u�ɏpHЦˏZ��>@�~�8Қ�6E!c؍m&�X��`�M7�_������/���a=k         �   x�����0D��T�쵗]��e�8%qdAT�� ��?z1�^��+'��)�Y3��B�|�HX��b�[j{��E�͆�ʻ"�.
�2M�f�f�P"]�9s	��8�5�l�x ��&al[�!����)���9�+B          P   x�3�HLO�M�+�W(JMK-�R�sJ���3sr2s9MM�8��LuLu��9}S�s2SSR�b���� ��3     