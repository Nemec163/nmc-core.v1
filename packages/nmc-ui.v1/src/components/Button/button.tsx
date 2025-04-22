import styles from './button.module.scss';

import React, { ReactNode } from 'react';

interface ButtonProps{
  children?: any;
  onClick?: (e: any) => void;
  prefix?: ReactNode;
  suffix?: ReactNode;
  template?: string;
  size?: string;
  href?: string;
  target?: string;
  disabled?: boolean;
  loading?: boolean;
  className?: string;
  type?: string;
  submit?: boolean;
  form?: string;
  isActive?: boolean;
}

const Button = ({
  children, 
  onClick, 
  prefix, 
  suffix,
  template = 'red',
  size = 'md',
  href, 
  target, 
  disabled,
  loading,
  className,
  type,
  submit,
  form,
  isActive
}: ButtonProps) => {

  const handleMouseDown = (e: React.MouseEvent) => {if (!disabled && !loading) e.currentTarget.classList.add(styles.active)};
  const handleMouseUp = (e: React.MouseEvent) => e.currentTarget.classList.remove(styles.active);

  const params = {
    onClick: disabled || loading ? undefined : onClick,
    onPointerDown: handleMouseDown,
    onPointerUp: handleMouseUp,
    onPointerCancel: handleMouseUp,
    className: `${styles.glow} ${styles.component} ${template ? styles[template] : ''} ${size ? styles[size] : ''} ${isActive ? styles.active : ''} ${disabled ? styles.disabled : ''} ${className ? className : ''}`,
    href: disabled || loading ? undefined : href,
    form
  }

  const content = (
    <>
      {prefix && <div className={styles.prefix}>{prefix}</div>}
      {children}
      {suffix && <div className={styles.suffix}>{suffix}</div>}
    </>
  );

  if (type === 'external' || (href && onClick)) return <a {...params}>{content}</a>;
  if (target) return <a target={target} {...params}>{content}</a>;
  // if (href && !onClick) return <Link href={params.href as string} className={params.className}>{content}</Link>;
  return <button type={submit ? 'submit' : 'button'} {...params}>{content}</button>;
};

export default Button;