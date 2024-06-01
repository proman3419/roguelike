# roguelike

![](readme/gameplay.png)

Gra składa się z poziomów, każdy z nich składa się z:
- losowo generowanej mapy
- losowo rozmieszczonych przeciwników

Celem gracza jest pokonanie wszystkich przeciwników na mapie za pomocą dystansowych ataków.\
Przeciwnicy zadają obrażenia graczowi również za pomocą dystansowych ataków. \

## Przeciwnicy
- ![](assets/characters/elemental.png) - atak długodystansowy
- ![](assets/characters/slime.png) - atak krótkodystansowy

## Wzmocnienia
Po wyeliminowaniu wszystkich przeciwników gracz wybiera jedną z nagród.

![](readme/powerups.png)

- ![](assets/powerups/cooldown.png) - szybkość ataku (jak często można atakować)
- ![](assets/powerups/damage.png) - obrażenia ataku (jak dużo punktów życia zabiera trafiony atak)
- ![](assets/powerups/gold.png) - złoto (zwiększa końcowy wynik)
- ![](assets/powerups/health.png) - życie
- ![](assets/powerups/speed.png) - szybkość poruszania

## Koniec gry
Gra nie posiada innego zakończenia niż przegrana. \
Jeżeli liczba punktów życia spadnie do 0 lub poniżej gra się kończy.

![](readme/defeat.png)
