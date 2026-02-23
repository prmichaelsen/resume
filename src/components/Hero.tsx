import { Link } from 'react-router-dom'
import '../styles/hero.css'

export default function Hero() {
  return (
    <div className="hero">
      <div className="hero-content">
        <h1 className="hero-title">Patrick Michaelsen</h1>
        <h2 className="hero-subtitle">Full Stack Software Engineer</h2>
        <p className="hero-tagline">
          Specializing in AI/ML and Agentic Systems | 8 years of experience building scalable solutions
        </p>
        <div className="hero-cta">
          <Link to="/portfolio" className="cta-button cta-primary">
            View Portfolio
          </Link>
          <Link to="/cv" className="cta-button cta-secondary">
            View CV
          </Link>
        </div>
      </div>
    </div>
  )
}
