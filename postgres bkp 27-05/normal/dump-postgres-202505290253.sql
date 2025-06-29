PGDMP      5                }            postgres    17.0    17.0 3    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false            �           1262    5    postgres    DATABASE        CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Portuguese_Brazil.1252';
    DROP DATABASE postgres;
                     postgres    false            �           0    0    DATABASE postgres    COMMENT     N   COMMENT ON DATABASE postgres IS 'default administrative connection database';
                        postgres    false    4857                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
                     pg_database_owner    false            �           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                        pg_database_owner    false    4            �            1259    32772    alunos    TABLE     �  CREATE TABLE public.alunos (
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
       public         heap r       postgres    false    4            �            1259    41004    alunos_aulas    TABLE     b   CREATE TABLE public.alunos_aulas (
    aluno_id integer NOT NULL,
    aula_id integer NOT NULL
);
     DROP TABLE public.alunos_aulas;
       public         heap r       postgres    false    4            �            1259    40993    aulas    TABLE     �   CREATE TABLE public.aulas (
    id integer NOT NULL,
    local character varying NOT NULL,
    status_aula integer DEFAULT 1 NOT NULL,
    datahora timestamp without time zone NOT NULL,
    idprofessor integer NOT NULL
);
    DROP TABLE public.aulas;
       public         heap r       postgres    false    4            �            1259    40992    aulas_id_seq    SEQUENCE     �   ALTER TABLE public.aulas ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.aulas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public               postgres    false    4    222            �            1259    49222    despesas    TABLE     �   CREATE TABLE public.despesas (
    id integer NOT NULL,
    descricao character varying(255) NOT NULL,
    valor numeric(12,2) NOT NULL,
    data date NOT NULL,
    categoria character varying(100)
);
    DROP TABLE public.despesas;
       public         heap r       postgres    false    4            �            1259    49221    despesas_id_seq    SEQUENCE     �   CREATE SEQUENCE public.despesas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.despesas_id_seq;
       public               postgres    false    227    4            �           0    0    despesas_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.despesas_id_seq OWNED BY public.despesas.id;
          public               postgres    false    226            �            1259    49230    mensalidades    TABLE     �   CREATE TABLE public.mensalidades (
    id integer NOT NULL,
    aluno_id integer NOT NULL,
    nome_aluno text NOT NULL,
    valor numeric(10,2) NOT NULL,
    data_vencimento date NOT NULL,
    esta_pago boolean DEFAULT false
);
     DROP TABLE public.mensalidades;
       public         heap r       postgres    false    4            �            1259    49229    mensalidades_id_seq    SEQUENCE     �   CREATE SEQUENCE public.mensalidades_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.mensalidades_id_seq;
       public               postgres    false    229    4            �           0    0    mensalidades_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.mensalidades_id_seq OWNED BY public.mensalidades.id;
          public               postgres    false    228            �            1259    32771    pessoas_id_seq    SEQUENCE     �   CREATE SEQUENCE public.pessoas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.pessoas_id_seq;
       public               postgres    false    4    218            �           0    0    pessoas_id_seq    SEQUENCE OWNED BY     @   ALTER SEQUENCE public.pessoas_id_seq OWNED BY public.alunos.id;
          public               postgres    false    217            �            1259    40969    professores    TABLE     �  CREATE TABLE public.professores (
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
       public         heap r       postgres    false    4            �            1259    40968    professores_id_seq    SEQUENCE     �   ALTER TABLE public.professores ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.professores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public               postgres    false    220    4            �            1259    49213    recebimentos    TABLE     �   CREATE TABLE public.recebimentos (
    id integer NOT NULL,
    descricao character varying(255) NOT NULL,
    valor numeric(12,2) NOT NULL,
    data date NOT NULL,
    categoria character varying(100)
);
     DROP TABLE public.recebimentos;
       public         heap r       postgres    false    4            �            1259    49216    recebimentos_id_seq    SEQUENCE     �   CREATE SEQUENCE public.recebimentos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.recebimentos_id_seq;
       public               postgres    false    4    224            �           0    0    recebimentos_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.recebimentos_id_seq OWNED BY public.recebimentos.id;
          public               postgres    false    225            >           2604    49217 	   alunos id    DEFAULT     g   ALTER TABLE ONLY public.alunos ALTER COLUMN id SET DEFAULT nextval('public.pessoas_id_seq'::regclass);
 8   ALTER TABLE public.alunos ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    217    218    218            A           2604    49225    despesas id    DEFAULT     j   ALTER TABLE ONLY public.despesas ALTER COLUMN id SET DEFAULT nextval('public.despesas_id_seq'::regclass);
 :   ALTER TABLE public.despesas ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    227    226    227            B           2604    49233    mensalidades id    DEFAULT     r   ALTER TABLE ONLY public.mensalidades ALTER COLUMN id SET DEFAULT nextval('public.mensalidades_id_seq'::regclass);
 >   ALTER TABLE public.mensalidades ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    228    229    229            @           2604    49218    recebimentos id    DEFAULT     r   ALTER TABLE ONLY public.recebimentos ALTER COLUMN id SET DEFAULT nextval('public.recebimentos_id_seq'::regclass);
 >   ALTER TABLE public.recebimentos ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    225    224            �          0    32772    alunos 
   TABLE DATA           m   COPY public.alunos (id, nome, cpf, telefone, cep, estado, cidade, bairro, endereco, complemento) FROM stdin;
    public               postgres    false    218   ]:       �          0    41004    alunos_aulas 
   TABLE DATA           9   COPY public.alunos_aulas (aluno_id, aula_id) FROM stdin;
    public               postgres    false    223   ^;       �          0    40993    aulas 
   TABLE DATA           N   COPY public.aulas (id, local, status_aula, datahora, idprofessor) FROM stdin;
    public               postgres    false    222   �;       �          0    49222    despesas 
   TABLE DATA           I   COPY public.despesas (id, descricao, valor, data, categoria) FROM stdin;
    public               postgres    false    227   N<       �          0    49230    mensalidades 
   TABLE DATA           c   COPY public.mensalidades (id, aluno_id, nome_aluno, valor, data_vencimento, esta_pago) FROM stdin;
    public               postgres    false    229   �<       �          0    40969    professores 
   TABLE DATA           r   COPY public.professores (id, nome, cpf, telefone, cep, estado, cidade, bairro, endereco, complemento) FROM stdin;
    public               postgres    false    220   �<       �          0    49213    recebimentos 
   TABLE DATA           M   COPY public.recebimentos (id, descricao, valor, data, categoria) FROM stdin;
    public               postgres    false    224   }=                   0    0    aulas_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.aulas_id_seq', 32, true);
          public               postgres    false    221                       0    0    despesas_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.despesas_id_seq', 1, true);
          public               postgres    false    226                       0    0    mensalidades_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.mensalidades_id_seq', 4, true);
          public               postgres    false    228                       0    0    pessoas_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.pessoas_id_seq', 79, true);
          public               postgres    false    217                       0    0    professores_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.professores_id_seq', 38, true);
          public               postgres    false    219                       0    0    recebimentos_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.recebimentos_id_seq', 45, true);
          public               postgres    false    225            M           2606    41008    alunos_aulas alunos_aulas_pkey 
   CONSTRAINT     k   ALTER TABLE ONLY public.alunos_aulas
    ADD CONSTRAINT alunos_aulas_pkey PRIMARY KEY (aluno_id, aula_id);
 H   ALTER TABLE ONLY public.alunos_aulas DROP CONSTRAINT alunos_aulas_pkey;
       public                 postgres    false    223    223            K           2606    41000    aulas aulas_pk 
   CONSTRAINT     L   ALTER TABLE ONLY public.aulas
    ADD CONSTRAINT aulas_pk PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.aulas DROP CONSTRAINT aulas_pk;
       public                 postgres    false    222            Q           2606    49227    despesas despesas_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.despesas
    ADD CONSTRAINT despesas_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.despesas DROP CONSTRAINT despesas_pkey;
       public                 postgres    false    227            S           2606    49238    mensalidades mensalidades_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.mensalidades
    ADD CONSTRAINT mensalidades_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.mensalidades DROP CONSTRAINT mensalidades_pkey;
       public                 postgres    false    229            E           2606    32779    alunos pessoas_cpf_key 
   CONSTRAINT     P   ALTER TABLE ONLY public.alunos
    ADD CONSTRAINT pessoas_cpf_key UNIQUE (cpf);
 @   ALTER TABLE ONLY public.alunos DROP CONSTRAINT pessoas_cpf_key;
       public                 postgres    false    218            G           2606    32777    alunos pessoas_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.alunos
    ADD CONSTRAINT pessoas_pkey PRIMARY KEY (id);
 =   ALTER TABLE ONLY public.alunos DROP CONSTRAINT pessoas_pkey;
       public                 postgres    false    218            I           2606    40975    professores professores_pk 
   CONSTRAINT     X   ALTER TABLE ONLY public.professores
    ADD CONSTRAINT professores_pk PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.professores DROP CONSTRAINT professores_pk;
       public                 postgres    false    220            O           2606    49220    recebimentos recebimentos_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.recebimentos
    ADD CONSTRAINT recebimentos_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.recebimentos DROP CONSTRAINT recebimentos_pkey;
       public                 postgres    false    224            T           2606    41009    alunos_aulas fk_aluno    FK CONSTRAINT     �   ALTER TABLE ONLY public.alunos_aulas
    ADD CONSTRAINT fk_aluno FOREIGN KEY (aluno_id) REFERENCES public.alunos(id) ON DELETE CASCADE;
 ?   ALTER TABLE ONLY public.alunos_aulas DROP CONSTRAINT fk_aluno;
       public               postgres    false    218    223    4679            U           2606    41014    alunos_aulas fk_aula    FK CONSTRAINT     �   ALTER TABLE ONLY public.alunos_aulas
    ADD CONSTRAINT fk_aula FOREIGN KEY (aula_id) REFERENCES public.aulas(id) ON DELETE CASCADE;
 >   ALTER TABLE ONLY public.alunos_aulas DROP CONSTRAINT fk_aula;
       public               postgres    false    223    4683    222            �   �   x�m��n�0Eg�+�A!�z��;(Z�k&R�dȲ�~}e���N��!pUK������e����JyoQ�y�io���
%�k��K�I����9&�J$���K�ew)J��]�6@
Ѧ��0��o��)��}�J�U9��O�pk�(�)8&��j��O�)P�MC7�	�6�� �\b����؜χU=MĔ�[��&pV
'�Cĭ4�Z{n��=p�y��@;�>�c�N�\�      �   "   x�3�42�2�46�2�L�9�,��9W� Kw      �   �   x�m�=�0��>E.��~��$+37`������KZ�"�2~�9����������� %|P	� -4{��0��k��? c��2�����8_4�P��-;��U]�|K�6����7N�`���B�(IjS42gL���ԍ���*͵�<����.��}���x�N|����)H�      �   6   x�3�,K�JT(H,JT���-H�J�445�30�4202�50�5���p��qqq ~�      �   Y   x�3�4�t�KT��)K�465�30�4202�50�50�L�2�4�tN,��/V�/��Pdh Td�i��Z�������������*F��� �i      �   p   x���K�0�ϧ�(q�:�K7�b	B��$N_8C��h��S���
-V$_�s���eS�E9'�ݻ7ǭz��sƾ5�|��2��_G���4ur��BI�<��D���Bn      �   q   x�}�K
B1F�q��l�^Bm.BpN~i�@�[u�:҉8;p�K����Z���]l���Q���KqTJ;]E(J�Et�{:X�P<#[HJ�������B>��3�o�"��Bx�"4     