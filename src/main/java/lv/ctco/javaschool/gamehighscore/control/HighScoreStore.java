package lv.ctco.javaschool.gamehighscore.control;

import lv.ctco.javaschool.auth.entity.domain.User;
import lv.ctco.javaschool.gamehighscore.entity.HighScore;

import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Stateless
public class HighScoreStore {
    @PersistenceContext
    private EntityManager em;


    public void setCurrentUserHighScore(User user, HighScore hs) {
        Optional<HighScore> highScore = this.getCurrentUserHighScore(user);
        if (!highScore.isPresent()) {
            em.persist(hs);
        } else {
            HighScore bestScore = highScore.get();
            if (!bestScore.isBetter(hs)) {
                bestScore = hs;
            }
        }
    }

    private Optional<HighScore> getCurrentUserHighScore(User user) {
        return em.createQuery(
                "select hs " +
                        "from HighScore hs " +
                        "where hs.user = :user", HighScore.class)
                .setParameter("user", user)
                .getResultStream()
                .findFirst();
    }

    public List<HighScore> getTenHighestScores() {
        return em.createQuery(
                "select hs " +
                        "from HighScore hs " +
                        "order by hs.bestScore", HighScore.class)
                .setMaxResults(10)
                .getResultStream()
                .collect(Collectors.toList());
    }
}
