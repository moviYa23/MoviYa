'use client';

import { useState } from 'react';
import { Search, MapPin, Clock } from 'lucide-react';
import { motion } from 'framer-motion';

interface SearchBarProps {
  onSearch: (query: string, destination: string, urgency: string) => void;
  loading: boolean;
}

export default function SearchBar({ onSearch, loading }: SearchBarProps) {
  const [query, setQuery] = useState('');
  const [destination, setDestination] = useState('Medellín, Colombia');
  const [urgency, setUrgency] = useState('week');

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (query.trim()) {
      onSearch(query, destination, urgency);
    }
  };

  return (
    <motion.form
      onSubmit={handleSubmit}
      initial={{ opacity: 0, scale: 0.95 }}
      animate={{ opacity: 1, scale: 1 }}
      className="glass p-8 rounded-3xl max-w-4xl mx-auto"
    >
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-4">
        {/* Query Input */}
        <div className="md:col-span-2 relative">
          <Search className="absolute left-4 top-4 text-gold" size={20} />
          <input
            type="text"
            placeholder="Search products..."
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            className="w-full bg-white/10 border border-white/20 rounded-lg pl-12 pr-4 py-3 text-white placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-gold"
          />
        </div>

        {/* Destination */}
        <div className="relative">
          <MapPin className="absolute left-4 top-4 text-gold" size={20} />
          <input
            type="text"
            placeholder="Destination"
            value={destination}
            onChange={(e) => setDestination(e.target.value)}
            className="w-full bg-white/10 border border-white/20 rounded-lg pl-12 pr-4 py-3 text-white placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-gold"
          />
        </div>
      </div>

      {/* Urgency & Submit */}
      <div className="flex gap-4 items-center">
        <div className="flex items-center gap-2 flex-1">
          <Clock size={20} className="text-gold" />
          <select
            value={urgency}
            onChange={(e) => setUrgency(e.target.value)}
            className="bg-white/10 border border-white/20 rounded-lg px-4 py-3 text-white focus:outline-none focus:ring-2 focus:ring-gold flex-1"
          >
            <option value="today">Today</option>
            <option value="week">This Week</option>
            <option value="month">This Month</option>
          </select>
        </div>

        <button
          type="submit"
          disabled={loading}
          className="bg-gradient-gold text-onyx font-bold px-8 py-3 rounded-lg hover:shadow-lg hover:shadow-gold/50 transition disabled:opacity-50 disabled:cursor-not-allowed"
        >
          {loading ? 'Searching...' : 'Search'}
        </button>
      </div>
    </motion.form>
  );
}
