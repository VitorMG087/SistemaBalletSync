namespace SistemaBalletSync.Services
{
    public class SessaoUsuario
    {
        public Usuario? Usuario { get; private set; }

        public void Logar(Usuario usuario)
        {
            Usuario = usuario;
        }

        public void Deslogar()
        {
            Usuario = null;
        }
    }
}
