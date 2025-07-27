import { useState, useEffect } from 'react'
import { useIntersectionObserver } from '../hooks/useIntersectionObserver'

export function LazyImage({ src, alt, className, placeholder }) {
  const [imageSrc, setImageSrc] = useState(placeholder || '')
  const [imageLoaded, setImageLoaded] = useState(false)
  const { ref, isIntersecting } = useIntersectionObserver({
    threshold: 0,
    rootMargin: '50px',
  })

  useEffect(() => {
    if (isIntersecting && src && !imageLoaded) {
      const img = new Image()
      img.src = src
      img.onload = () => {
        setImageSrc(src)
        setImageLoaded(true)
      }
    }
  }, [isIntersecting, src, imageLoaded])

  return (
    <div ref={ref} className={`relative overflow-hidden ${className}`}>
      {!imageLoaded && (
        <div className="absolute inset-0 bg-gray-200 animate-pulse" />
      )}
      <img
        src={imageSrc}
        alt={alt}
        className={`w-full h-full object-cover transition-opacity duration-300 ${
          imageLoaded ? 'opacity-100' : 'opacity-0'
        }`}
        loading="lazy"
      />
    </div>
  )
}