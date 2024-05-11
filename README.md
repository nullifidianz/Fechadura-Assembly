
## Authors

- [João Paulo Paggi Zuanon Dias](https://github.com/nullifidianz)
- [Thales Clemente Pasquotto](https://github.com/thaleeews)

# Sistema de Fechadura Com senha em Assembly 8051

Este projeto consiste na implementação de uma interface de teclado matricial com um display LCD e um motor simulando uma fechadura controlado por um microcontrolador utilizando a linguagem de programação Assembly.

# Objetivo
O objetivo principal deste projeto é criar um sistema de entrada de uma senha em um microcontrolador usando um teclado matricial e exibir mensagens no display LCD de acordo com o PIN inserido com a finalidade de entender melhor a estrutura da arquitetura de computadores e da linguagem Assembly.

# Funcionalidades
- Interface de Teclado Matricial: O sistema permite que o usuário insira o PIN por meio de um teclado matricial 4x4.
- Exibição no Display LCD: As mensagens são exibidas em um display LCD de acordo com as interações do usuário. O armazenamento é realizado a partir de tabelas LUT (Lookup Tables) para facilitar a exibição de textos e afins.
- Verificação da senha: O sistema verifica se a senha inserida pelo usuário está correta.
- Feedback Visual: Fornece feedback visual ao usuário através do display LCD, indicando se o acesso foi concedido ou negado.
- Botão para alterar a senha: Após inserir a senha corretamente, o usuário pode pressionar o botão "#" para alterar o PIN da fechadura.
  
# Componentes Utilizados
- Microcontrolador 8051
- Teclado Matricial 4x4
- Display LCD

**Todos os componentes utilizados foram emulados no simulador Edsim51**


# Funcionamento

Fluxograma da lógica de Funcionamento:

![Fluxograma](https://github.com/nullifidianz/Fechadura-Assembly/blob/main/img/fluxograma.png)


**A frenquência recomendada para testes é de 100hz para exibição inicial da mensagem e 10hz antes de fazer os inputs de teclado**

**Caso a frequência seja maior, ocorrerá erro de multiplas entradas no teclado matricial**
**A frenquência recomendada para testes é de 100hz para exibição inicial da mensagem e 10hz antes de fazer os inputs de teclado**

**Caso a frequência seja maior, ocorrerá erro de multiplas entradas no teclado matricial**
Quando o PIN é pedido:
- A função Main é chamada.
- A função ExibeDisplay é chamada para exibir a mensagem "Digite o PIN:".
- O loop Novamente é executado para exibir os caracteres da mensagem na tela.
- A função ScanTeclado é chamada para aguardar a entrada do PIN pelo teclado.
- Depois que o PIN é digitado, o programa verifica se a entrada está correta ou não usando a função VerificarEntrada.
- Se o PIN estiver correto, a função Concedido é chamada para exibir "Acesso Concedido".
- Se o PIN estiver incorreto, a função Negado é chamada para exibir "Acesso Negado".

**Quando o PIN correto é digitado:**
- A função VerificarEntrada é chamada após cada tecla pressionada para verificar se o PIN está correto.
- Se todas as teclas estiverem corretas, a função Concedido é chamada para conceder acesso.
- Após a verificação do PIN correto na função Concedido, o programa SETA o pino de controle do motor (P3.0) para girar no sentido anti-horário.
- Em seguida, é iniciado um temporizador para aguardar meia volta do motor.
- Após o término do temporizador, o programa DESATIVA o pino de controle do motor (P3.0) para interromper o movimento.

**Quando o PIN errado é digitado:**
- A função VerificarEntrada é chamada após cada tecla pressionada para verificar se o PIN está correto.
- Se alguma tecla estiver incorreta, a função Negado é chamada para negar o acesso..




## Screenshots
Acesso Condedido - 

![Gif acesso_concedido](https://github.com/nullifidianz/Fechadura-Assembly/blob/main/img/acesso_concedido.gif)

Acesso Negado - 

![Gif acesso_negado](https://github.com/nullifidianz/Fechadura-Assembly/blob/main/img/acesso_negado.gif)


## Documentação Utilizada

[EdSim51's Users Guide](http://edsim51.com/simInstructions.html)

[MCS@51 MICROCONTROLLER FAMILY USER’S MANUAL](https://web.mit.edu/6.115/www/document/8051.pdf)

[Assembly para 8051 - canal WR Kits](https://www.youtube.com/@canalwrkits)
