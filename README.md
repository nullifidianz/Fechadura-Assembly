
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
**A frenquência recomendada para testes é de 100hz para exibição inicial da mensagem e 10hz antes de fazer os inputs de teclado**

**Caso a frequência seja maior, ocorrerá erro de multiplas entradas no teclado matricial**
- O sistema exibe a mensagem "Entrar PIN:" no display LCD.
- O usuário insere o PIN usando o teclado matricial.
- O sistema verifica se o PIN inserido está correto.
- Se o PIN estiver correto, exibe a mensagem "Acesso Concedido".
- Caso contrário, exibe a mensagem "Acesso Negado".
- A partir do "Acesso Concedido", o usuário pode alterar o PIN clicando no botão "#".
## Documentação Utilizada

[EdSim51's Users Guide](http://edsim51.com/simInstructions.html)

[MCS@51 MICROCONTROLLER FAMILY USER’S MANUAL](https://web.mit.edu/6.115/www/document/8051.pdf)

[Assembly para 8051 - canal WR Kits](https://www.youtube.com/@canalwrkits)
