'use client';

import { motion } from 'framer-motion';

interface PriceComparisonProps {
  results: any[];
}

export default function PriceComparison({ results }: PriceComparisonProps) {
  if (!results.length) return null;

  // Agrupar por fuente
  const grouped = results.reduce((acc, item) => {
    if (!acc[item.source]) acc[item.source] = [];
    acc[item.source].push(item);
    return acc;
  }, {} as Record<string, any[]>);

  const sources = Object.entries(grouped).map(([source, items]) => ({
    source,
    avgPrice: items.reduce((sum, item) => sum + item.price, 0) / items.length,
    count: items.length,
  })).sort((a, b) => a.avgPrice - b.avgPrice);

  const cheapest = sources[0];

  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      className="glass p-6 rounded-2xl"
    >
      <h3 className="text-2xl font-bold mb-6 text-gold">Price Comparison</h3>

      <div className="space-y-4">
        {sources.map((item, i) => (
          <div
            key={i}
            className={`p-4 rounded-lg border transition ${
              item.source === cheapest.source
                ? 'border-gold bg-gold/10'
                : 'border-white/20 bg-white/5 hover:bg-white/10'
            }`}
          >
            <div className="flex justify-between items-center">
              <div>
                <h4 className="font-bold text-white uppercase text-lg">{item.source}</h4>
                <p className="text-sm text-gray-400">{item.count} products found</p>
              </div>
              <div className="text-right">
                <div className="text-3xl font-bold text-gold">${item.avgPrice.toFixed(2)}</div>
                {item.source === cheapest.source && (
                  <div className="text-xs text-gold font-semibold mt-1">💰 Best Price</div>
                )}
              </div>
            </div>
          </div>
        ))}
      </div>
    </motion.div>
  );
}
