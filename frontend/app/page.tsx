'use client';

import { useState } from 'react';
import SearchBar from '@/components/SearchBar';
import ProductGrid from '@/components/ProductGrid';
import PriceComparison from '@/components/PriceComparison';
import { motion } from 'framer-motion';

export default function Home() {
  const [searchResults, setSearchResults] = useState([]);
  const [loading, setLoading] = useState(false);

  const handleSearch = async (query: string, destination: string, urgency: string) => {
    setLoading(true);
    try {
      const response = await fetch('/api/search', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ query, destination, urgency }),
      });
      const data = await response.json();
      setSearchResults(data.results || []);
    } catch (error) {
      console.error('Search error:', error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <main className="min-h-screen bg-gradient-to-br from-onyx via-onyx-light to-onyx">
      {/* Navigation */}
      <nav className="glass border-b border-white/10 sticky top-0 z-50">
        <div className="max-w-7xl mx-auto px-6 py-4 flex justify-between items-center">
          <div className="gradient-text text-2xl font-bold">MoviYa</div>
          <div className="flex gap-4 items-center">
            <button className="text-amber hover:text-gold transition">Dashboard</button>
            <button className="glass px-6 py-2 rounded-lg hover:bg-white/30">Connect Wallet</button>
          </div>
        </div>
      </nav>

      {/* Hero Section */}
      <section className="max-w-7xl mx-auto px-6 py-20">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.8 }}
          className="text-center mb-12"
        >
          <h1 className="text-5xl font-bold mb-4">
            <span className="gradient-text">Global E-Commerce</span>
            {' '}
            <span className="text-white">Orchestrated by AI</span>
          </h1>
          <p className="text-xl text-gray-400 max-w-2xl mx-auto">
            Find the best products from Amazon, AliExpress & Temu. Get instant shipping quotes from Uber, DiDi & Rappi.
          </p>
        </motion.div>

        {/* Search Bar */}
        <SearchBar onSearch={handleSearch} loading={loading} />

        {/* Price Comparison */}
        {searchResults.length > 0 && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            className="mt-12"
          >
            <PriceComparison results={searchResults} />
          </motion.div>
        )}

        {/* Product Grid */}
        {searchResults.length > 0 && (
          <ProductGrid products={searchResults} />
        )}
      </section>

      {/* Features Section */}
      <section className="bg-onyx-light/50 py-20 mt-20">
        <div className="max-w-7xl mx-auto px-6">
          <h2 className="text-3xl font-bold mb-12 text-center gradient-text">Why MoviYa</h2>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            {[
              { title: 'AI Orchestration', desc: 'Smart agents find the best deals instantly' },
              { title: 'Dynamic Pricing', desc: 'Fair commissions based on value saved' },
              { title: 'Tokenized Rewards', desc: 'Earn MYT tokens on every purchase' },
            ].map((feature, i) => (
              <div key={i} className="glass p-6 rounded-xl">
                <h3 className="font-bold text-lg mb-2 text-gold">{feature.title}</h3>
                <p className="text-gray-300">{feature.desc}</p>
              </div>
            ))}
          </div>
        </div>
      </section>
    </main>
  );
}
