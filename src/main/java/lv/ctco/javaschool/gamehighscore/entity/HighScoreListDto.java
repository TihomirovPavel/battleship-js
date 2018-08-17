package lv.ctco.javaschool.gamehighscore.entity;

import lombok.Data;

import java.util.List;

@Data
public class HighScoreListDto {
    private List<HighScoreDto> listHs;
}
