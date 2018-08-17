package lv.ctco.javaschool.game.control;

import lv.ctco.javaschool.auth.entity.domain.User;
import lv.ctco.javaschool.game.entity.Cell;
import lv.ctco.javaschool.game.entity.CellState;
import lv.ctco.javaschool.game.entity.Game;
import lv.ctco.javaschool.game.entity.GameStatus;

import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Stateless
public class GameStore {
    @PersistenceContext
    private EntityManager em;


    public Optional<Game> getIncompleteGame() {
        return em.createQuery(
                "select g " +
                        "from Game g " +
                        "where g.status = :status", Game.class)
                .setParameter("status", GameStatus.INCOMPLETE)
                .setMaxResults(1)
                .getResultStream()
                .findFirst();
    }

    public Optional<Game> getStartedGameFor(User user, GameStatus status) {
        return em.createQuery(
                "select g " +
                        "from Game g " +
                        "where g.status = :status " +
                        "  and (g.player1 = :user " +
                        "   or g.player2 = :user)", Game.class)
                .setParameter("status", status)
                .setParameter("user", user)
                .getResultStream()
                .findFirst();
    }

    public Optional<Game> getLastGame(User user) {
        return em.createQuery(
                "select g " +
                        "from Game g " +
                        "where (g.player1 = :user " +
                        "   or g.player2 = :user)" +
                        " order by g.id DESC", Game.class)
                .setParameter("user", user)
                .setMaxResults(1)
                .getResultStream()
                .findFirst();
    }

    public Optional<Cell> findCell(Game game, User player, String address, boolean targetArea) {
        return em.createQuery(
                "select c from Cell c " +
                        "where c.game = :game " +
                        "  and c.user = :user " +
                        "  and c.targetArea = :target " +
                        "  and c.address = :address", Cell.class)
                .setParameter("game", game)
                .setParameter("user", player)
                .setParameter("target", targetArea)
                .setParameter("address", address)
                .getResultStream()
                .findFirst();
    }

    public void setCellState(Game game, User player, String address, boolean targetArea, CellState state) {
        Optional<Cell> cell = findCell(game, player, address, targetArea);
        if (cell.isPresent()) {
            cell.get().setState(state);
        } else {
            Cell newCell = new Cell();
            newCell.setGame(game);
            newCell.setUser(player);
            newCell.setAddress(address);
            newCell.setTargetArea(targetArea);
            newCell.setState(state);
            em.persist(newCell);
        }
    }

    public void setShips(Game game, User player, boolean targetArea, List<String> ships) {
        clearField(game, player, targetArea);
        ships.stream()
                .map(addr -> {
                    Cell c = new Cell();
                    c.setGame(game);
                    c.setAddress(addr);
                    c.setTargetArea(targetArea);
                    c.setUser(player);
                    c.setState(CellState.SHIP);
                    return c;
                }).forEach(c -> em.persist(c));
    }

    private void clearField(Game game, User player, boolean targetArea) {
        List<Cell> cells = em.createQuery(
                "select c " +
                        "from Cell c " +
                        "where c.game = :game " +
                        "  and c.user = :user " +
                        "  and c.targetArea = :target", Cell.class)
                .setParameter("game", game)
                .setParameter("user", player)
                .setParameter("target", targetArea)
                .getResultList();
        cells.forEach(c -> em.remove(c));
    }

    public List<Cell> getCells(Game game, User player) {
        return em.createQuery(
                "select c " +
                        "from Cell c " +
                        "where c.game = :game " +
                        "  and c.user = :user ", Cell.class)
                .setParameter("game", game)
                .setParameter("user", player)
                .getResultList();
    }

    public boolean checkIfHasShips(User user) {
        Optional<Game> game = this.getLastGame(user);
        boolean hasShips = false;
        List<Cell> cells = new ArrayList<>();
        if (game.isPresent()) {
            Game g = game.get();
            cells = getCells(g, user);
            for (Cell cell : cells) {
                if (cell.getState() == CellState.SHIP && !(cell.isTargetArea())) {
                    hasShips = true;
                }
            }
        }
        return hasShips;
    }
}