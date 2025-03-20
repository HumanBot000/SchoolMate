// utils/math.test.js
import { add, subtract } from './math';

describe('Math Utilities', () => {
  describe('add', () => {
    it('should add two positive numbers', () => {
      expect(add(2, 3)).toBe(5);
    });

    it('should add a positive and a negative number', () => {
      expect(add(5, -3)).toBe(2);
    });

    it('should add two negative numbers', () => {
      expect(add(-2, -3)).toBe(-5);
    });
  });

  describe('subtract', () => {
    it('should subtract two positive numbers', () => {
      expect(subtract(5, 3)).toBe(2);
    });

    it('should subtract a negative number from a positive number', () => {
      expect(subtract(5, -3)).toBe(8);
    });

    it('should subtract a positive number from a negative number', () => {
      expect(subtract(-5, 3)).toBe(-8);
    });
  });
});
