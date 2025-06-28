public class SessaoUsuario
{
    public Usuario? UsuarioLogado { get; private set; }

    public bool EstaLogado => UsuarioLogado != null;

    public void Logar(Usuario usuario)
    {
        UsuarioLogado = usuario;
    }

    public void Deslogar()
    {
        UsuarioLogado = null;
    }

}
