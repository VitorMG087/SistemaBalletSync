PGDMP                      }            postgres    15.2    17.4 3    8           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false            9           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false            :           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false            ;           1262    5    postgres    DATABASE        CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Portuguese_Brazil.1252';
    DROP DATABASE postgres;
                     postgres    false            <           0    0    DATABASE postgres    COMMENT     N   COMMENT ON DATABASE postgres IS 'default administrative connection database';
                        postgres    false    3387                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
                     pg_database_owner    false            =           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
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
    complemento character varying,
    tipo_plano character varying(50),
    valor_plano numeric(10,2)
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
            public               postgres    false    217    5            �            1259    16413    despesas    TABLE     �   CREATE TABLE public.despesas (
    id integer NOT NULL,
    descricao character varying(255) NOT NULL,
    valor numeric(12,2) NOT NULL,
    data date NOT NULL,
    categoria character varying(100)
);
    DROP TABLE public.despesas;
       public         heap r       postgres    false    5            �            1259    16416    despesas_id_seq    SEQUENCE     �   CREATE SEQUENCE public.despesas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.despesas_id_seq;
       public               postgres    false    219    5            >           0    0    despesas_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.despesas_id_seq OWNED BY public.despesas.id;
          public               postgres    false    220            �            1259    16417    mensalidades    TABLE     �   CREATE TABLE public.mensalidades (
    id integer NOT NULL,
    aluno_id integer NOT NULL,
    nome_aluno text NOT NULL,
    valor numeric(10,2) NOT NULL,
    data_vencimento date NOT NULL,
    esta_pago boolean DEFAULT false
);
     DROP TABLE public.mensalidades;
       public         heap r       postgres    false    5            �            1259    16423    mensalidades_id_seq    SEQUENCE     �   CREATE SEQUENCE public.mensalidades_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.mensalidades_id_seq;
       public               postgres    false    5    221            ?           0    0    mensalidades_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.mensalidades_id_seq OWNED BY public.mensalidades.id;
          public               postgres    false    222            �            1259    16424    pessoas_id_seq    SEQUENCE     �   CREATE SEQUENCE public.pessoas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.pessoas_id_seq;
       public               postgres    false    215    5            @           0    0    pessoas_id_seq    SEQUENCE OWNED BY     @   ALTER SEQUENCE public.pessoas_id_seq OWNED BY public.alunos.id;
          public               postgres    false    223            �            1259    16425    professores    TABLE     �  CREATE TABLE public.professores (
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
       public         heap r       postgres    false    5            �            1259    16430    professores_id_seq    SEQUENCE     �   ALTER TABLE public.professores ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.professores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public               postgres    false    224    5            �            1259    16431    recebimentos    TABLE     �   CREATE TABLE public.recebimentos (
    id integer NOT NULL,
    descricao character varying(255) NOT NULL,
    valor numeric(12,2) NOT NULL,
    data date NOT NULL,
    categoria character varying(100)
);
     DROP TABLE public.recebimentos;
       public         heap r       postgres    false    5            �            1259    16434    recebimentos_id_seq    SEQUENCE     �   CREATE SEQUENCE public.recebimentos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.recebimentos_id_seq;
       public               postgres    false    5    226            A           0    0    recebimentos_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.recebimentos_id_seq OWNED BY public.recebimentos.id;
          public               postgres    false    227            �           2604    16435 	   alunos id    DEFAULT     g   ALTER TABLE ONLY public.alunos ALTER COLUMN id SET DEFAULT nextval('public.pessoas_id_seq'::regclass);
 8   ALTER TABLE public.alunos ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    223    215            �           2604    16436    despesas id    DEFAULT     j   ALTER TABLE ONLY public.despesas ALTER COLUMN id SET DEFAULT nextval('public.despesas_id_seq'::regclass);
 :   ALTER TABLE public.despesas ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    220    219            �           2604    16437    mensalidades id    DEFAULT     r   ALTER TABLE ONLY public.mensalidades ALTER COLUMN id SET DEFAULT nextval('public.mensalidades_id_seq'::regclass);
 >   ALTER TABLE public.mensalidades ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    222    221            �           2604    16438    recebimentos id    DEFAULT     r   ALTER TABLE ONLY public.recebimentos ALTER COLUMN id SET DEFAULT nextval('public.recebimentos_id_seq'::regclass);
 >   ALTER TABLE public.recebimentos ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    227    226            )          0    16398    alunos 
   TABLE DATA           �   COPY public.alunos (id, nome, cpf, telefone, cep, estado, cidade, bairro, endereco, complemento, tipo_plano, valor_plano) FROM stdin;
    public               postgres    false    215   �:       *          0    16403    alunos_aulas 
   TABLE DATA           9   COPY public.alunos_aulas (aluno_id, aula_id) FROM stdin;
    public               postgres    false    216   �;       +          0    16406    aulas 
   TABLE DATA           N   COPY public.aulas (id, local, status_aula, datahora, idprofessor) FROM stdin;
    public               postgres    false    217   <       -          0    16413    despesas 
   TABLE DATA           I   COPY public.despesas (id, descricao, valor, data, categoria) FROM stdin;
    public               postgres    false    219   �<       /          0    16417    mensalidades 
   TABLE DATA           c   COPY public.mensalidades (id, aluno_id, nome_aluno, valor, data_vencimento, esta_pago) FROM stdin;
    public               postgres    false    221   =       2          0    16425    professores 
   TABLE DATA           r   COPY public.professores (id, nome, cpf, telefone, cep, estado, cidade, bairro, endereco, complemento) FROM stdin;
    public               postgres    false    224   �=       4          0    16431    recebimentos 
   TABLE DATA           M   COPY public.recebimentos (id, descricao, valor, data, categoria) FROM stdin;
    public               postgres    false    226   >       B           0    0    aulas_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.aulas_id_seq', 32, true);
          public               postgres    false    218            C           0    0    despesas_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.despesas_id_seq', 1, true);
          public               postgres    false    220            D           0    0    mensalidades_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.mensalidades_id_seq', 4, true);
          public               postgres    false    222            E           0    0    pessoas_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.pessoas_id_seq', 82, true);
          public               postgres    false    223            F           0    0    professores_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.professores_id_seq', 38, true);
          public               postgres    false    225            G           0    0    recebimentos_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.recebimentos_id_seq', 51, true);
          public               postgres    false    227            �           2606    16440    alunos_aulas alunos_aulas_pkey 
   CONSTRAINT     k   ALTER TABLE ONLY public.alunos_aulas
    ADD CONSTRAINT alunos_aulas_pkey PRIMARY KEY (aluno_id, aula_id);
 H   ALTER TABLE ONLY public.alunos_aulas DROP CONSTRAINT alunos_aulas_pkey;
       public                 postgres    false    216    216            �           2606    16442    aulas aulas_pk 
   CONSTRAINT     L   ALTER TABLE ONLY public.aulas
    ADD CONSTRAINT aulas_pk PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.aulas DROP CONSTRAINT aulas_pk;
       public                 postgres    false    217            �           2606    16444    despesas despesas_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.despesas
    ADD CONSTRAINT despesas_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.despesas DROP CONSTRAINT despesas_pkey;
       public                 postgres    false    219            �           2606    16446    mensalidades mensalidades_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.mensalidades
    ADD CONSTRAINT mensalidades_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.mensalidades DROP CONSTRAINT mensalidades_pkey;
       public                 postgres    false    221            �           2606    16448    alunos pessoas_cpf_key 
   CONSTRAINT     P   ALTER TABLE ONLY public.alunos
    ADD CONSTRAINT pessoas_cpf_key UNIQUE (cpf);
 @   ALTER TABLE ONLY public.alunos DROP CONSTRAINT pessoas_cpf_key;
       public                 postgres    false    215            �           2606    16450    alunos pessoas_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.alunos
    ADD CONSTRAINT pessoas_pkey PRIMARY KEY (id);
 =   ALTER TABLE ONLY public.alunos DROP CONSTRAINT pessoas_pkey;
       public                 postgres    false    215            �           2606    16452    professores professores_pk 
   CONSTRAINT     X   ALTER TABLE ONLY public.professores
    ADD CONSTRAINT professores_pk PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.professores DROP CONSTRAINT professores_pk;
       public                 postgres    false    224            �           2606    16454    recebimentos recebimentos_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.recebimentos
    ADD CONSTRAINT recebimentos_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.recebimentos DROP CONSTRAINT recebimentos_pkey;
       public                 postgres    false    226            �           2606    16455    alunos_aulas fk_aluno    FK CONSTRAINT     �   ALTER TABLE ONLY public.alunos_aulas
    ADD CONSTRAINT fk_aluno FOREIGN KEY (aluno_id) REFERENCES public.alunos(id) ON DELETE CASCADE;
 ?   ALTER TABLE ONLY public.alunos_aulas DROP CONSTRAINT fk_aluno;
       public               postgres    false    216    3212    215            �           2606    16460    alunos_aulas fk_aula    FK CONSTRAINT     �   ALTER TABLE ONLY public.alunos_aulas
    ADD CONSTRAINT fk_aula FOREIGN KEY (aula_id) REFERENCES public.aulas(id) ON DELETE CASCADE;
 >   ALTER TABLE ONLY public.alunos_aulas DROP CONSTRAINT fk_aula;
       public               postgres    false    217    216    3216            )   2  x����n�0Dϓ�� d;v���P�p�e!n�
bpH��:@�J���H^��y#K�(zbO;v>d�talɅ��M2I��'s�z���8��6=	��miC-�>�MX�@u�\`����#����g
UKlMm:|�J�E�N��\]i�5��{�!̨w�+b1�&ϩ#�\ۍ�g߇���m\k$�\[!r(U��(���7�C���6���3�n
11>�q����_�%�S�Oob�1ue��"/���e��	:�����#�J�i�"ď`G�#�E�^�y%�����v��8 �#B�/�e�e�py�      *   "   x�3�42�2�46�2�L�9�,��9W� Kw      +   �   x�m�=�0��>E.��~��$+37`������KZ�"�2~�9����������� %|P	� -4{��0��k��? c��2�����8_4�P��-;��U]�|K�6����7N�`���B�(IjS42gL���ԍ���*͵�<����.��}���x�N|����)H�      -   6   x�3�,K�JT(H,JT���-H�J�445�30�4202�50�5���p��qqq ~�      /   Y   x�3�4�t�KT��)K�465�30�4202�50�50�,�2�4�tK-�K�KIT����PehTe�i��X��_��_Z��� �(F��� �K�      2   p   x���K�0�ϧ�(q�:�K7�b	B��$N_8C��h��S���
-V$_�s���eS�E9'�ݻ7ǭz��sƾ5�|��2��_G���4ur��BI�<��D���Bn      4      x������ � �     