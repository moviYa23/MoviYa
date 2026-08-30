'use client';

import { motion } from 'framer-motion';

interface Product {
  id: string;
  name: string;
  price: number;
  source: string;
  shipping: string;
  rating?: number;
}

interface ProductGridProps {
  products: Product[];
}

export default function ProductGrid({ products }: ProductGridProps) {
  return (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mt-8">
      {products.map((product, i) => (
        <motion.div
          key={product.id}
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: i * 0.1 }}
          className="glass p-6 rounded-xl hover:bg-white/20 transition group cursor-pointer"
        >
          <div className="flex justify-between items-start mb-4">
            <h3 className="font-bold text-lg text-white flex-1">{product.name}</h3>
            <span className="bg-gold/20 text-gold px-3 py-1 rounded-full text-xs font-semibold">
              {product.source.toUpperCase()}
            </span>
          </div>

          <div className="space-y-3">
            <div className="flex justify-between items-center">
              <span className="text-gray-400">Price:</span>
              <span className="text-2xl font-bold text-gold">${product.price.toFixed(2)}</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-gray-400">Shipping:</span>
              <span className="text-white">{product.shipping}</span>
            </div>
            {product.rating && (
              <div className="flex justify-between items-center">
                <span className="text-gray-400">Rating:</span>
                <span className="text-amber">{'⭐'.repeat(Math.floor(product.rating))}</span>
              </div>
            )}
          </div>

          <button className="w-full mt-4 bg-gradient-gold text-onyx font-bold py-2 rounded-lg group-hover:shadow-lg group-hover:shadow-gold/50 transition">
            View & Buy
          </button>
        </motion.div>
      ))}
    </div>
  );
}
