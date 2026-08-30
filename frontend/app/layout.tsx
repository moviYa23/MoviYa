import type { Metadata } from 'next';
import './globals.css';

export const metadata: Metadata = {
  title: 'MoviYa - Global E-Commerce & Logistics Platform',
  description: 'AI-Orchestrated platform for smart shopping and delivery',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en" className="dark">
      <body className="bg-onyx text-white">
        {children}
      </body>
    </html>
  );
}
