package lv.ctco.javaschool.gamehighscore.boundary;


import lombok.extern.java.Log;
import lv.ctco.javaschool.auth.control.UserStore;
import lv.ctco.javaschool.auth.entity.domain.User;
import lv.ctco.javaschool.game.control.GameStore;
import lv.ctco.javaschool.game.entity.Game;
import lv.ctco.javaschool.game.entity.GameStatus;
import lv.ctco.javaschool.gamehighscore.control.HighScoreStore;
import lv.ctco.javaschool.gamehighscore.entity.HighScore;
import lv.ctco.javaschool.gamehighscore.entity.HighScoreDto;
import lv.ctco.javaschool.gamehighscore.entity.HighScoreListDto;

import javax.annotation.security.RolesAllowed;
import javax.ejb.Stateless;
import javax.inject.Inject;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Path("/high-score")
@Stateless
@Log
public class HighScoreApi {
    @Inject
    private UserStore userStore;
    @Inject
    private GameStore gameStore;
    @Inject
    private HighScoreStore highScoreStore;

    @GET
    @RolesAllowed({"ADMIN", "USER"})
    public HighScoreListDto getHighScores() {
        List<HighScore> highScores = highScoreStore.getTenHighestScores();
        List<HighScoreDto> highScoreDtos = new ArrayList<>();
        highScores.forEach(hs -> {
            HighScoreDto hsDto = new HighScoreDto();
            hsDto.setBestScore(hs.getBestScore());
            hsDto.setUserName(hs.getUser().getUsername());
            highScoreDtos.add(hsDto);
        });
        HighScoreListDto hsList = new HighScoreListDto();
        hsList.setListHs(highScoreDtos);
        return hsList;
    }

    @POST
    @RolesAllowed({"ADMIN", "USER"})
    public void setScoreIfHighest() {
        HighScore highScore = new HighScore();
        User user = userStore.getCurrentUser();
        Optional<Game> game = gameStore.getLastGame(user);
        if (game.isPresent()) {
            Game g = game.get();
            if (g.getStatus() == GameStatus.FINISHED) {
                highScore.setUser(user);
                highScore.setBestScore(g.getUsersScore(user));
                highScoreStore.setCurrentUserHighScore(user, highScore);
            }
        }

    }
}
