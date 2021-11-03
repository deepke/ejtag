unsigned int 
strlen(const char *p)
{
	int n;

	if (!p)
		return (0);
	for (n = 0; *p; p++)
		n++;
	return (n);
}


size_t strnlen(const char * s, size_t count)
{
	const char *sc;

	for (sc = s; count-- && *sc != '\0'; ++sc)
		/* nothing */;
	return sc - s;
}
