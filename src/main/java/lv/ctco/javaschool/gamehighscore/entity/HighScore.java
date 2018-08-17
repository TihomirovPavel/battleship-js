package lv.ctco.javaschool.gamehighscore.entity;

import lombok.Data;
import lv.ctco.javaschool.auth.entity.domain.User;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.OneToOne;

@Data
@Entity
public class HighScore {
    @Id
    @GeneratedValue
    private Long id;

    @OneToOne
    private User user;

    private int bestScore;


    public boolean isBetter(HighScore hs) {
        return bestScore > hs.getBestScore();
    }
}
