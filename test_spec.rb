require_relative 'game'

describe 'Game of Life' do
  describe World do
    let(:world) { World.new }
    describe 'has methods' do
      it { should respond_to(:cols) }
      it { should respond_to(:grid) }
      it { should respond_to(:cells) }
      it { should respond_to(:live_cells) }
      it { should respond_to(:live_neighbors_of) }
    end

    it 'creates a grid of Cell objects' do
      expect(world.grid.is_a?(Array)).to be true
      world.cells.each do |cell|
        expect(cell.is_a?(Cell)).to be true
        expect(cell.alive?).to be false
      end
    end

    context 'live_cells' do
      it 'finds all live cells in a world' do
        cell1 = world.grid[1][1]
        cell2 = world.grid[0][0]
        cell3 = world.grid[1][2]
        cell4 = world.grid[1][0]
        cell1.lives
        cell2.lives
        cell3.lives
        cell4.lives
        expect(world.live_cells.count).to eq(4)
      end
    end

    context 'live_neighbors_of' do
      it 'finds live neighbors of a cell' do
        cell1 = world.grid[1][1]
        cell2 = world.grid[0][0]
        cell3 = world.grid[1][2]
        cell4 = world.grid[1][0]
        expect(cell1.dead?).to be true
        cell1.lives
        cell2.lives
        cell3.lives
        cell4.lives
        expect(world.live_neighbors_of(cell1).count).to eq(3)
        expect(world.live_neighbors_of(cell2).count).to eq(2)
        expect(world.live_neighbors_of(cell3).count).to eq(1)
        expect(world.live_neighbors_of(cell4).count).to eq(2)
      end
    end

  end

  describe Cell do
    let(:cell) { Cell.new }
    context 'has methods' do
      it { should respond_to(:alive) }
      it { should respond_to(:alive?) }
      it { should respond_to(:dead?) }
      it { should respond_to(:lives) }
      it { should respond_to(:dies) }
    end

    it 'checks if cell is alive or dead' do
      expect(cell.dead?).to be true
    end

    it 'can set a cell to live or die' do
      cell.lives
      expect(cell.alive?).to be true
      expect(cell.dead?).to be false

      cell.dies
      expect(cell.dead?).to be true
      expect(cell.alive?).to be false
    end
  end

  describe Game do
    let(:game) { Game.new }
    let(:world) { World.new }
    context 'has methods' do
      it { should respond_to(:world) }
      it { should respond_to(:seeds) }
      it { should respond_to(:tick) }
    end

    it 'initializes' do
      expect(game.world.is_a?(World)).to be true
      expect(game.seeds.is_a?(Array)).to be true
    end

    context '#1: Any live cell with fewer than two live neighbours dies,\
      as if caused by underpopulation.' do
      it 'Kills live cell with 0 live neighbors' do
        game = Game.new(world, [[1, 1]])
        game.tick
        expect(game.world.grid[1][1]).to be_dead
      end

      it 'Kills live cell with 1 live neighbor' do
        game = Game.new(world, [[0, 1], [1, 1]])
        game.tick
        expect(game.world.grid[1][1]).to be_dead
        expect(game.world.grid[0][1]).to be_dead
      end
    end

    context '#2: Any live cell with more than three live neighbours dies,\
      as if by overcrowding.' do
      it 'Kills live cell with > 3 live neighbors' do
        game = Game.new(world, [[0, 2], [1, 1], [2, 1], [2, 0], [0, 0]])
        game.tick
        expect(game.world.grid[1][1]).to be_dead
        expect(game.world.grid[0][0]).to be_dead
        expect(game.world.grid[0][2]).to be_dead
        expect(game.world.grid[2][1]).to be_alive
        expect(game.world.grid[2][0]).to be_alive
      end
    end

    context '#3: Any live cell with two or three live neighbours lives\
      on to the next generation' do
      it 'Continues live cell with 2 live neighbors' do
        game = Game.new(world, [[0, 2], [1, 1], [2, 1]])
        game.tick
        expect(game.world.grid[1][1]).to be_alive
        expect(game.world.grid[0][2]).to be_dead
        expect(game.world.grid[2][1]).to be_dead
      end

      it 'Continues live cell with 3 live neighbors' do
        game = Game.new(world, [[0, 2], [1, 1], [2, 1], [2, 0]])
        game.tick
        expect(game.world.grid[1][1]).to be_alive
        expect(game.world.grid[0][2]).to be_dead
        expect(game.world.grid[2][1]).to be_alive
        expect(game.world.grid[2][0]).to be_alive
      end
    end

    context 'Rule 4: Any dead cell with exactly 3 live neighbours\
      becomes a live cell.' do
      it 'Revives dead cell with 3 live neighbors' do
        game = Game.new(world, [[0, 0], [1, 2], [2, 2]])
        game.tick
        expect(game.world.grid[1][1]).to be_alive
        expect(game.world.grid[0][0]).to be_dead
        expect(game.world.grid[1][2]).to be_dead
        expect(game.world.grid[2][2]).to be_dead
      end
    end
  end
end
