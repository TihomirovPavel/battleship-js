package lv.ctco.javaschool.game.entity;

import lombok.Data;
import lv.ctco.javaschool.auth.entity.domain.User;

import javax.persistence.*;

@Data
@Entity
public class Game {
    @Id
    @GeneratedValue
    private Long id;

    @ManyToOne
    private User player1;
    private boolean player1Active;
    private int MovesCounterP1;

    @ManyToOne
    private User player2;
    private boolean player2Active;
    private int MovesCounterP2;

    @Enumerated(EnumType.STRING)
    private GameStatus status;


    public boolean isPlayerActive(User player) {
        if (player.equals(player1)) {
            return player1Active;
        } else if (player.equals(player2)) {
            return player2Active;
        } else {
            throw new IllegalArgumentException();
        }
    }

    public int getUsersScore(User user) {
        if (user.equals(this.getPlayer1())) {
            return this.getMovesCounterP1();
        } else if (user.equals(this.getPlayer2())) {
            return this.getMovesCounterP2();
        } else {
            throw new IllegalArgumentException();
        }
    }


    public void setPlayerActive(User player, boolean active) {
        if (player.equals(player1)) {
            player1Active = active;
        } else if (player.equals(player2)) {
            player2Active = active;
        } else {
            throw new IllegalArgumentException();
        }
    }

    public User getOpponent(User currentPlayer) {
        if (player1.equals(currentPlayer)) {
            return player2;
        }
        return player1;
    }

    public void countMove(User currentUser) {
        int count;
        if (currentUser == player1) {
            count = this.getMovesCounterP1();
            this.setMovesCounterP1(count + 1);
        } else if (currentUser == player2) {
            count = this.getMovesCounterP2();
            this.setMovesCounterP2(count + 1);
        }
    }
}
